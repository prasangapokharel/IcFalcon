---
name: googleCalendarConnectorStandard
description: >-
  List/create events on user's Google Calendar via googlecalendar-client +
  google-oauth. FreeBusy for availability. Per-user OAuth PKCE.
---

# Google Calendar Connector

Interact with the **signed-in user's Google Calendar** — list events, create
appointments, check availability.

**Distinct from:** [`../../extensionsStandard/emailCalendarEventsStandard/SKILL.md`](../../extensionsStandard/emailCalendarEventsStandard/SKILL.md)
which emails ICS invites from the app.

**Prerequisites:**
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md)

```bash
cd backend && mops add googlecalendar-client@0.1.4
cd backend && mops add google-oauth@0.2.1
```

---

## Capabilities

| Intent | API |
|---|---|
| List upcoming events | `calendar_events_list` |
| Create event | `calendar_events_insert` |
| Check free/busy slots | `calendar_freebusy_query` — not events list |

Use FreeBusy for booking / Calendly-style availability.

---

## Auth model

Same as Gmail connector:

1. Admin sets Google Client ID + Secret.
2. Per-user OAuth PKCE — tokens by `caller : Principal`.
3. All endpoints require signed-in caller.

See [`googleMailConnector/SKILL.md`](googleMailConnector/SKILL.md) for OAuth flow.

---

## Service layers

```
api/v1/Calendar.mo  →  services/GoogleCalendarService.mo  →  googlecalendar-client
```

Token refresh in service before each outcall batch.

---

## Outcall rules

- `is_replicated = ?false` always.
- Never hand-roll Google HTTP.
- Admin secrets never returned to frontend.

---

## Related

| Topic | Path |
|---|---|
| Gmail connector | [`googleMailConnector/SKILL.md`](googleMailConnector/SKILL.md) |
| Email ICS invites | [`../../extensionsStandard/emailCalendarEventsStandard/SKILL.md`](../../extensionsStandard/emailCalendarEventsStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
