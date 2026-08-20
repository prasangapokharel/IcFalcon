---
name: slackConnectorStandard
description: >-
  Post messages to Slack from the canister via slack-client mops package.
  Bot (xoxb) or user (xoxp) token, admin-gated setter, non-replicated outcalls.
---

# Slack Connector

Post messages to a Slack workspace from the backend canister.

**Prerequisites:**
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md),
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md)

```bash
cd backend && mops add slack-client@0.0.3
```

---

## Token choice

| Appears as | Token | Notes |
|---|---|---|
| The app (APP badge) | `xoxb-` bot | Default. Invite bot to each channel. |
| A specific person | `xoxp-` user | Audited as that human. No channel invite needed. |

Ask the user which they need before coding. Admin pastes token via gated setter.

---

## Security

- Token in canister state only — never returned to frontend.
- Admin-gated `setSlackToken` — never first-caller-ownership.
- `is_replicated = ?false` on every Slack outcall.
- Bearer only in `Authorization` header — never in URL.

---

## Service pattern

```motoko
import { chatPostMessage } "mo:slack-client/Apis/ChatApi";

public func postMessage(
  service : SlackService,
  channel : Text,
  text : Text,
) : async Types.ApiResult<Text> {
  if (service.token.size() == 0) {
    return Result.err(Result.badRequest, "Slack not configured");
  };
  // chatPostMessage with config.auth = ?#bearer(token), is_replicated = ?false
};
```

Handle `{"ok":false}` Slack errors as rejected calls / `ApiResult` errors.

---

## IPv4

`slack.com` is IPv4-only — IC retries via SOCKS proxy since 2025-08-04. Leave
default `baseUrl`.

---

## Related

| Topic | Path |
|---|---|
| HTTP outcalls | [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
