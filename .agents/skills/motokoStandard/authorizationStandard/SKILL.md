---
name: authorizationStandard
description: >-
  IcFalcon auth and RBAC — caller verification, roles, service guards, frontend
  II session. Read before adding protected endpoints or admin-only secrets.
---

# Authorization

IcFalcon uses Internet Identity on the frontend and principal-based RBAC on
the backend. No external auth package — use `mo:pkg/principal/caller`,
`mo:pkg/rbac/rbac`, and `UserService`.

**Prerequisites:**
[`../internetIdentityAuthStandard/SKILL.md`](../internetIdentityAuthStandard/SKILL.md),
[`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md),
[`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md)

---

## Backend roles

`mo:pkg/rbac/rbac`:

| Role | Typical use |
|---|---|
| `#owner` | Full access |
| `#admin` | Manage users, set API keys, config |
| `#member` | Authenticated user |
| `#guest` | Read-only public data |

Check with `Rbac.can(role, action)` or `Rbac.require(role, action)`.

---

## Service guard pattern

Every service method that mutates or reads private data:

```motoko
import Caller "mo:pkg/principal/caller";
import Rbac "mo:pkg/rbac/rbac";

public func createItem(
  service : ItemService,
  caller : Principal,
  name : Text,
) : async Types.ApiResult<Types.Item> {
  switch (Caller.requireAuth(caller)) {
    case (?message) { return Result.err(Result.unauthorized, message) };
    case (null) {};
  };

  let userRole = switch (UserRepo.getById(service.userStore, caller)) {
    case (?user) { user.role };
    case (null) { return Result.err(Result.unauthorized, "Register first") };
  };

  switch (Rbac.require(userRole, #write)) {
    case (?message) { return Result.err(Result.forbidden, message) };
    case (null) {};
  };

  // business logic ...
};
```

Rules:

- Never accept `Principal` as a parameter for authorization — use `{ caller }`.
- Return `ApiResult` errors — avoid `Runtime.trap` for expected auth failures.
- Admin-only secret setters: require `#admin` or `#owner`.

---

## API layer

`api/v1/` mixins pass `MiddlewareAuth.effectiveCaller(mwConfig, caller)` to
services. Dev mode can impersonate a caller — see `middleware/Auth.mo`.

```motoko
public shared ({ caller }) func createShop(name : Text) : async Types.ApiResult<Types.Shop> {
  await ShopService.create(
    shopService,
    MiddlewareAuth.effectiveCaller(mwConfig, caller),
    name,
  );
};
```

---

## Registration flow

1. User signs in with Internet Identity (frontend).
2. Frontend calls `register(username)` once — creates user with `#member`.
3. Subsequent calls use `me()` or feature endpoints.
4. First user promotion to `#admin` — explicit seed or admin assignment endpoint.

Session restore must call a mutating login/register path, not only a query —
see `internetIdentityAuthStandard`.

---

## Frontend

| Concern | Path |
|---|---|
| II provider | `components/auth/AuthProvider.tsx` |
| Actor factory | `services/client.ts` |
| Auth state | hooks wrapping identity + actor |

Gate UI on authenticated identity, not on one-time login success flags.
On logout, clear SWR cache and stored session.

```tsx
const { identity } = useAuth()

{identity ? <App /> : <LoginScreen />}
```

Never create `HttpAgent` outside `services/client.ts`.

---

## Secret storage (API keys, tokens)

For OpenAI, Slack, Stripe, and similar:

- Store in stable or transient service state on the canister.
- Set via admin-gated update endpoint only.
- Never return secrets in query responses.
- Never use first-caller-ownership for secret setters.

---

## Related

| Topic | Path |
|---|---|
| II delegation constraint | [`../internetIdentityAuthStandard/SKILL.md`](../internetIdentityAuthStandard/SKILL.md) |
| HTTP outcalls + secrets | [`../httpOutcallsStandard/SKILL.md`](../httpOutcallsStandard/SKILL.md) |
| Errors | [`../../errorHandlingStandard/SKILL.md`](../../errorHandlingStandard/SKILL.md) |
| Frontend | [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
