---
name: inviteLinksStandard
description: >-
  Invite codes and guest RSVP without login — admins generate codes, guests submit
  via URL param. IcFalcon layered implementation. Read before RSVP/event features.
---

# Invite Links & RSVP

Admins generate invite codes; guests submit RSVPs without authentication.

**Prerequisites:**
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

```bash
falcon m:f Invite
```

---

## Types (`types.mo`)

```motoko
public type InviteCode = {
  code : Text;
  createdAt : Int;
  used : Bool;
};

public type Rsvp = {
  name : Text;
  attending : Bool;
  timestamp : Int;
  inviteCode : Text;
};
```

---

## Layers

| Layer | Methods |
|---|---|
| `storage/InviteStorage.mo` | Maps for codes and RSVPs |
| `repositories/InviteRepository.mo` | CRUD |
| `services/InviteService.mo` | `generateCode`, `submitRsvp`, `listRsvps`, `listCodes` |
| `validators/InviteValidator.mo` | Code format, name length |
| `api/v1/Invite.mo` | Thin endpoints |

---

## Endpoints

| Method | Auth | Action |
|---|---|---|
| `generateInviteCode` | Admin | Create new code |
| `submitRsvp` | Anonymous OK | Guest submits with code |
| `getAllRsvps` | Admin | List responses |
| `getInviteCodes` | Admin | List codes |

Use `Caller.requireAuth` + `Rbac.require(#admin, #manage)` for admin endpoints.
Guest submit validates code exists and is unused.

---

## Frontend

- Admin dashboard: `components/invite/InviteAdminPanel.tsx`
- Guest form: `components/invite/GuestRsvpForm.tsx`
- Parse `?code=xyz` from URL on mount.
- Copy link: `${origin}?code=${code}` to clipboard.
- Hooks: `useInviteCodes`, `useRsvps`, `useSubmitRsvp` in `hooks/invite/`.
- Services: `services/invite/invite.ts`

Gate admin view on user role from `me()` profile.

---

## Related

| Topic | Path |
|---|---|
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
| Frontend | [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
