---
name: emailStandard
description: >-
  Transactional/service email from the canister — order confirmations, notifications.
  Not for marketing blasts. Use services layer + HTTP outcall or hub email pkg.
---

# Transactional Email

One-off service emails: order confirmations, password resets, alerts.

**Not for:** marketing campaigns (see `emailMarketingStandard`) or verification links
(see `emailVerificationStandard`).

**Prerequisites:**
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

```bash
falcon add pkg email
```

Or integrate SendGrid/Resend/Postmark via `OutcallService`.

---

## Service pattern

```motoko
public func sendOrderConfirmation(
  service : EmailService,
  recipient : Text,
  subject : Text,
  htmlBody : Text,
) : async Types.ApiResult<()> {
  switch (EmailValidator.validateAddress(recipient)) {
    case (?msg) { return Result.err(Result.badRequest, msg) };
    case (null) {};
  };
  await EmailProvider.send(service.config, recipient, subject, htmlBody);
};
```

- One recipient per call for privacy (each gets individual email).
- Return `ApiResult` — map provider errors to `#err`, do not trap.
- Call from feature services, not directly from `api/`.

---

## Configuration

Provider API key in canister state — admin-gated setter. From address/username
configured once (e.g. `no-reply@yourdomain.com`).

Verify provider API with curl before deploy.

---

## Related

| Topic | Path |
|---|---|
| Multi-recipient | [`../emailRawStandard/SKILL.md`](../emailRawStandard/SKILL.md) |
| Verification | [`../emailVerificationStandard/SKILL.md`](../emailVerificationStandard/SKILL.md) |
| HTTP outcalls | [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md) |
