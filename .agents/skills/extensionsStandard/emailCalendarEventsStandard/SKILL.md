---
name: emailCalendarEventsStandard
description: >-
  Send iCalendar (.ics) invitations by email — meeting invites with RSVP.
  Distinct from Google Calendar connector (user's own calendar).
---

# Email Calendar Invites

Send meeting invitations as iCalendar attachments or embedded ICS bodies.

**Distinct from:** [`../../connectorsStandard/googleCalendarConnectorStandard/SKILL.md`](../../connectorsStandard/googleCalendarConnectorStandard/SKILL.md)
which writes to the user's Google Calendar directly.

**Prerequisites:**
[`../emailRawStandard/SKILL.md`](../emailRawStandard/SKILL.md) or [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md)

---

## ICS payload

Build RFC 5545 VEVENT in `lib/calendar/buildIcs.ts` (frontend) or
`services/CalendarInviteService.mo` (backend):

```
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:...
DTEND:...
SUMMARY:...
LOCATION:...
ORGANIZER:...
END:VEVENT
END:VCALENDAR
```

---

## Send flow

1. Admin or user creates event metadata.
2. Service builds ICS string.
3. Email sent with `text/calendar` part or `.ics` attachment.
4. Optional: track RSVP responses via separate invite-links module.

---

## Related

| Topic | Path |
|---|---|
| Raw email | [`../emailRawStandard/SKILL.md`](../emailRawStandard/SKILL.md) |
| Invite/RSVP | [`../inviteLinksStandard/SKILL.md`](../inviteLinksStandard/SKILL.md) |
| Google Calendar | [`../../connectorsStandard/googleCalendarConnectorStandard/SKILL.md`](../../connectorsStandard/googleCalendarConnectorStandard/SKILL.md) |
