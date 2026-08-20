---
name: httpOutcallsStandard
description: >-
  HTTP outcalls from the backend canister — bounded requests, non-replicated
  execution, curl verification, IcFalcon service-layer placement. Read before
  integrating any external REST API.
---

# HTTP Outcalls

Backend canister HTTP requests (GET, POST, PUT, DELETE, PATCH). Never call
external APIs from the frontend when secrets or billing matter — outcalls belong
in `services/`.

**Prerequisites:** [`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md),
[`../../codingStandard/SKILL.md`](../../codingStandard/SKILL.md)

**Used by:** connector and extension skills (Slack, OpenAI, Stripe, X, etc.)

---

## Layer placement

```
api/v1/<Name>.mo  →  services/<Name>OutcallService.mo  →  mo:pkg/http + IC
```

| Layer | Responsibility |
|---|---|
| `api/v1/` | Auth gate, delegate to service, return `ApiResult` |
| `services/` | Build URL, headers, body; call outcall helper; parse response |
| `pkg/http/` | Request types, size limits, shared helpers |

Never put `ic.http_request` in `api/`, `repositories/`, or `storage/`.

---

## Critical rules

1. **Server-side bounds required.** Every request must limit the response by
   identifier, pagination, time range, or result count — never fetch an
   unbounded collection and filter in the canister.
2. **Max 1 MB response, max 10_000 entries** — paginate beyond that.
3. **Put bounds in the actual URL/body** sent by Motoko, not only in tests.
4. **Non-replicated only.** Always `is_replicated = ?false`. Replicated
   outcalls leak bearer tokens across nodes and multiply billing 13×.
5. **Verify with curl before deploy.** Same method, path, params, headers, body
   as the Motoko implementation. Trace one user input end-to-end.
6. **Reject unsafe APIs.** If the provider cannot enforce a server-side bound,
   narrow the feature — do not ship fetch-all-then-filter.

### Wrong bound example

Flight lookup by callsign → do **not** fetch `states/all` and scan in Motoko.
Use the provider's identifier parameter (`?icao24=…`). Paginating a huge
collection still scales with collection size and hits instruction limits
(`IC0522`).

---

## Service pattern

Expose a query transform in `main.mo` (required by IC for response trimming):

```motoko
import Outcall "services/OutcallService";

persistent actor App {
  public query func transform(input : Outcall.TransformInput) : async Outcall.TransformOutput {
    Outcall.transform(input);
  };
};
```

`services/OutcallService.mo` wraps the management canister:

```motoko
import IC "mo:ic/IC";
import HttpTypes "mo:pkg/http/http";
import Blob "mo:core/Blob";
import Text "mo:core/Text";

module {
  public type TransformInput = { context : Blob; response : IC.http_request_result };
  public type TransformOutput = IC.http_request_result;

  public func transform(input : TransformInput) : TransformOutput {
    input.response;
  };

  public type OutcallError = { #http : Nat; #decode : Text; #tooLarge : Text };

  public func httpRequest(request : HttpTypes.Request) : async { #ok : Text; #err : OutcallError } {
    let icRequest : IC.http_request_args = {
      url = request.url;
      max_response_bytes = request.maxResponseBytes;
      method = switch (request.method) {
        case (#get) { #get };
        case (#post) { #post };
        case (#head) { #head };
      };
      headers = request.headers;
      body = request.body;
      transform = ?{
        function = transform;
        context = Blob.fromArray([]);
      };
      is_replicated = ?false;
    };
    let response = await IC.http_request(icRequest);
    if (response.status >= 400) {
      return #err(#http(response.status));
    };
    let bodyText = switch (Text.decodeUtf8(response.body)) {
      case (?t) { t };
      case (null) { return #err(#decode("Invalid UTF-8")) };
    };
    #ok(bodyText);
  };
};
```

Feature services import `OutcallService` — never call `IC.http_request` directly
from feature code.

---

## curl verification checklist

Before marking an outcall complete:

1. Same method, version, path, query params, headers, body as Motoko.
2. One representative user input traced through every conversion to the URL.
3. `curl --fail-with-body --silent --show-error` — verify status and every
   field the app consumes.
4. Confirm response size stays under 1 MB at realistic load.

Typical failures: `400` bad params, `404`/`410` obsolete endpoint, `405` wrong
method, `415` wrong content type, `429`/`5xx` quota or provider outage.

---

## Secrets and admin setters

API keys and bearer tokens live in canister state, set through **admin-gated**
endpoints (`mo:pkg/rbac/rbac` `#admin` or `#owner`). Never return secrets to the
frontend. Never gate a secret setter on first-caller-claims-ownership — all
anonymous callers share the same principal on IC.

See [`../authorizationStandard/SKILL.md`](../authorizationStandard/SKILL.md).

---

## Related

| Topic | Path |
|---|---|
| Layering | [`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md) |
| Auth / RBAC | [`../authorizationStandard/SKILL.md`](../authorizationStandard/SKILL.md) |
| Slack connector | [`../../connectorsStandard/slackConnectorStandard/SKILL.md`](../../connectorsStandard/slackConnectorStandard/SKILL.md) |
| OpenAI extension | [`../../extensionsStandard/openAiStandard/SKILL.md`](../../extensionsStandard/openAiStandard/SKILL.md) |
