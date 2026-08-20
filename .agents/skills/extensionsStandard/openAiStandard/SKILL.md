---
name: openAiStandard
description: >-
  OpenAI / LLM integration via mops openai-client — Chat, embeddings, images.
  Admin or per-user API keys, non-replicated outcalls. Read before ChatGPT/GPT work.
---

# OpenAI Integration

Canister calls to OpenAI REST API. Use the `openai-client` mops package — do not
hand-roll `ic.http_request` to `api.openai.com`.

**Prerequisites:**
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md),
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

---

## Dependencies

```bash
cd backend && mops add openai-client@0.2.5
```

Requires Mops ≥ 2.13.

---

## Auth model

OpenAI uses static `sk-...` API keys — no OAuth.

| Variant | When | Key storage |
|---|---|---|
| Per-user (default) | Multi-user app, each pays own usage | `Map<Principal, Text>` in storage |
| Admin-key | Operator funds all usage | Single key, admin-gated setter |
| Anonymous demo | No login, explicit single-user tool | Single key, no auth gate |

Per-user and admin variants require signed-in callers — see `authorizationStandard`.

---

## Non-replicated outcalls (required)

Every `Config` must set `is_replicated = ?false`. Bearer tokens are billing
secrets — replicated outcalls leak them across subnet nodes and multiply cost.

---

## Layer placement

```
api/v1/OpenAi.mo  →  services/OpenAiService.mo  →  openai-client APIs
```

Admin setter endpoint in `api/v1/` → `OpenAiService.setApiKey` (admin only).

Feature chat endpoint → `OpenAiService.chat` with caller's key or shared admin key.

---

## Service sketch

```motoko
import { chatCompletions } "mo:openai-client/Apis/ChatApi";
import { defaultConfig; type Config } "mo:openai-client/Config";

func clientConfig(apiKey : Text) : Config {
  {
    defaultConfig with
    auth = ?#bearer(apiKey);
    is_replicated = ?false;
    max_response_bytes = ?(1_000_000 : Nat64);
  };
};
```

Return `ApiResult` — map OpenAI errors to `Result.err`, never trap on expected failures.

---

## Frontend

- Key entry UI for per-user variant (never log or cache key in localStorage).
- Chat UI in `components/<feature>/` using hooks + services.
- Loading and error states via shadcn components.

---

## Related

| Topic | Path |
|---|---|
| HTTP outcalls | [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
