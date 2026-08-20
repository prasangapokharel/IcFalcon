---
name: stripeStandard
description: >-
  Stripe checkout sessions and payment status via HTTP outcalls. Admin secret key,
  shopping items, success/cancel URLs. Read before payment features.
---

# Stripe Payments

Stripe integration using HTTP outcalls from the backend canister.

**Prerequisites:**
[`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md),
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

```bash
cd backend && mops add stripe-client
```

Or implement via `OutcallService` + Stripe REST API with curl-verified requests.

---

## Configuration

Store in transient or stable service state (admin-gated setter):

```motoko
type StripeConfig = {
  secretKey : Text;
  allowedCountries : [Text];
};
```

Never return `secretKey` to the frontend.

---

## Flow

1. Admin sets Stripe secret key (`sk_live_...` or `sk_test_...`).
2. Authenticated user calls `createCheckoutSession(items, successUrl, cancelUrl)`.
3. Service creates Stripe Checkout Session via POST outcall.
4. Frontend redirects user to Stripe-hosted checkout URL.
5. On return, frontend calls `getSessionStatus(sessionId)` to confirm payment.
6. Fulfill order in service layer when status is `#completed`.

---

## Layer placement

```
api/v1/Payment.mo  →  services/StripeService.mo  →  OutcallService
```

Include `transform` query in `main.mo` for response trimming.

---

## Frontend

- Product/cart UI in `components/shop/`.
- Redirect to Stripe URL on session create.
- Success and cancel pages under `app/(app)/payment/`.
- Never embed secret key in frontend env.

---

## Related

| Topic | Path |
|---|---|
| HTTP outcalls | [`../../motokoStandard/httpOutcallsStandard/SKILL.md`](../../motokoStandard/httpOutcallsStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
