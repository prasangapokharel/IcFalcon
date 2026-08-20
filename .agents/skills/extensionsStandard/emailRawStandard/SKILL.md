---
name: emailRawStandard
description: >-
  Email with multiple to/cc/bcc recipients — same body to all. Not for bulk
  service mail (privacy). Max 50 recipients total.
---

# Raw Multi-Recipient Email

Send one email with explicit `to`, `cc`, and `bcc` lists.

**Warning:** All recipients see each other's addresses — do not use for
user-facing bulk notifications. Use [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md)
for per-recipient transactional mail.

**Prerequisites:** [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md)

---

## When to use

- Internal team reminders (meeting attendees all know each other).
- Small explicit recipient lists where shared visibility is acceptable.

---

## Service signature

```motoko
public func sendRawEmail(
  service : EmailService,
  to : [Text],
  cc : [Text],
  bcc : [Text],
  subject : Text,
  htmlBody : Text,
) : async Types.ApiResult<()>
```

- Max 50 total recipients across to + cc + bcc.
- Validate every address before send.
- Same HTML body for all.

---

## Related

| Topic | Path |
|---|---|
| Transactional | [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md) |
| Calendar invites | [`../emailCalendarEventsStandard/SKILL.md`](../emailCalendarEventsStandard/SKILL.md) |
