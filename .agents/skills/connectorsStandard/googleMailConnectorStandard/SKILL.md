---
name: googleMailConnectorStandard
description: >-
  Send email as the signed-in user's Gmail via googlemail-client + google-oauth.
  Per-user OAuth PKCE, admin Client ID/Secret. No hand-rolled Google HTTP.
---

# Gmail Connector

Send email through the **signed-in user's own Gmail** — not app transactional mail.

**Distinct from:** [`../../extensionsStandard/emailStandard/SKILL.md`](../../extensionsStandard/emailStandard/SKILL.md)

**Prerequisites:**
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md)

```bash
cd backend && mops add googlemail-client@0.1.6
cd backend && mops add google-oauth@0.2.1
```

---

## Dependencies

| Package | Role |
|---|---|
| `googlemail-client` | Gmail REST API bindings |
| `google-oauth` | PKCE, token exchange, refresh |

Never hand-roll `ic.http_request` to `oauth2.googleapis.com` or
`gmail.googleapis.com`.

---

## Auth model

1. Admin sets Google Cloud **Web application** Client ID + Secret (admin-gated).
2. Each user completes OAuth 2.0 PKCE flow — tokens keyed by `caller : Principal`.
3. `access_token` + `refresh_token` stored in canister; refresh on expiry.
4. All Gmail endpoints require signed-in caller.

---

## OAuth flow (frontend)

1. User clicks "Connect Gmail".
2. Frontend opens Google consent with PKCE challenge.
3. Redirect returns auth code → canister exchanges for tokens.
4. Send mail via service using stored per-user bearer.

---

## Outcall rules

- `is_replicated = ?false` on every Google API call.
- Single refresh retry on `401`.
- Secrets never returned to frontend.

---

## Related

| Topic | Path |
|---|---|
| App transactional email | [`../../extensionsStandard/emailStandard/SKILL.md`](../../extensionsStandard/emailStandard/SKILL.md) |
| Google Calendar | [`googleCalendarConnector/SKILL.md`](googleCalendarConnector/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
