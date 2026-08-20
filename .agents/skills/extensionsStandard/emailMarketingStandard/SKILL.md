---
name: emailMarketingStandard
description: >-
  Marketing email campaigns — batch sends with unsubscribe. Separate from
  transactional email. Requires consent tracking and rate limits.
---

# Email Marketing

Bulk marketing campaigns — newsletters, promotions, announcements.

**Not for:** transactional notifications — use [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md).

**Prerequisites:**
[`../emailStandard/SKILL.md`](../emailStandard/SKILL.md),
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md)

---

## Requirements

- Explicit opt-in per subscriber — store consent timestamp.
- Unsubscribe link in every message — honor immediately in storage.
- Admin-only campaign create/send endpoints.
- Rate-limit sends to avoid provider throttling.
- Per-recipient individual sends (recipients must not see each other).

---

## Layers

```
api/v1/Campaign.mo  →  services/CampaignService.mo  →  email provider
                      ↘  storage/SubscriberStorage.mo
```

Track: `Subscriber { email; optedIn; optedInAt; unsubscribedAt }`.

---

## Compliance

- Never email users who unsubscribed.
- Log campaign id + send time for audit.
- Validate email addresses before add.

---

## Related

| Topic | Path |
|---|---|
| Transactional | [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md) |
| Verification | [`../emailVerificationStandard/SKILL.md`](../emailVerificationStandard/SKILL.md) |
