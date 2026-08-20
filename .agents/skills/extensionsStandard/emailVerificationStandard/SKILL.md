---
name: emailVerificationStandard
description: >-
  Email ownership verification via click-to-verify link. Token generation,
  callback handler, verified set. Read before signup email confirm flows.
---

# Email Verification

Prove users own an email address via a signed verification link.

**Prerequisites:**
[`../emailStandard/SKILL.md`](../emailStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

---

## Backend

| Piece | Role |
|---|---|
| `storage/VerifiedEmailStorage.mo` | `Set` of verified addresses |
| `services/EmailVerificationService.mo` | Generate token, verify, check |
| `api/v1/EmailVerification.mo` | `sendVerification`, `verifyToken` |

Rules:

- Check verification with `VerifiedEmailStorage.contains(email)` only — do not
  duplicate status on user profile.
- Tokens: random, single-use, expiry timestamp.
- Verification link hits frontend route → calls `verifyToken(token)` update.

---

## Flow

1. User submits email → service sends link via transactional email.
2. Link: `https://app.example/verify?token=...`
3. Frontend page calls canister `verifyToken`.
4. On success, email added to verified set.
5. Feature gates check `isEmailVerified(email)` before proceeding.

---

## Frontend

- `components/auth/VerifyEmailPanel.tsx`
- Resend with rate limit feedback.
- Show verified badge after success.

---

## Related

| Topic | Path |
|---|---|
| Transactional email | [`../emailStandard/SKILL.md`](../emailStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
