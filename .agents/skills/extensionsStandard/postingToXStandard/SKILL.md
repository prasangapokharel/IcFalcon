---
name: postingToXStandard
description: >-
  Post tweets to X (Twitter) from the canister via OAuth bearer. Writes only —
  reads use httpOutcalls. Non-replicated outcalls required.
---

# Posting to X (Twitter)

Post tweets from the backend canister. **Writes only** — timeline search and
user lookup use [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md).

**Prerequisites:**
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md),
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md)

```bash
cd backend && mops add x-client
```

---

## Auth model

OAuth 2.0 bearer token per user or single admin token:

| Variant | Token storage | Setter gate |
|---|---|---|
| Per-user | `Map<Principal, Text>` | Authenticated user |
| Admin | Single token | `#admin` |

Obtain token from X Developer Portal. Never return bearer to frontend.

---

## Non-replicated (required)

`is_replicated = ?false` on every X API call. Replicated outcalls leak bearer
and multiply rate-limit consumption by subnet size.

---

## Service flow

1. Admin or user configures OAuth bearer.
2. `postTweet(text)` → POST `https://api.x.com/2/tweets` via outcall service.
3. Return tweet id on success; `ApiResult` on failure.
4. Respect X rate limits — queue or reject when throttled.

---

## Frontend

- Compose UI in `components/social/PostToXPanel.tsx`.
- Character count, error display for `429` / auth failures.
- No bearer token in browser.

---

## Related

| Topic | Path |
|---|---|
| HTTP outcalls | [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
