---
name: userApprovalStandard
description: >-
  Approval-based access — users request access, admins approve/reject. IcFalcon
  layered pattern on top of UserService and RBAC.
---

# User Approval

Users request access; admins approve or reject before protected features unlock.

**Prerequisites:**
[`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md),
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

---

## Types

```motoko
public type ApprovalStatus = { #approved; #rejected; #pending };

public type UserApproval = {
  principal : Principal;
  status : ApprovalStatus;
  requestedAt : Int;
};
```

Add `approvalStatus` to `User` record or separate `approvalStore` map.

---

## Service rules

- `isApproved(caller)` — admins always approved; others check status.
- `requestApproval(caller)` — sets `#pending` if not registered.
- `setApproval(admin, user, status)` — admin only.
- `listApprovals(admin)` — admin only.

On first deploy, seed existing admins as `#approved`.

Guard protected features:

```motoko
if (not UserApprovalService.isApproved(service, caller)) {
  return Result.err(Result.forbidden, "Awaiting approval");
};
```

---

## API endpoints

| Endpoint | Caller | Action |
|---|---|---|
| `isCallerApproved` | Auth | Query own status |
| `requestApproval` | Auth | Submit request |
| `listApprovals` | Admin | All users + status |
| `setApproval` | Admin | Approve/reject |

---

## Frontend

- Pending screen for non-approved users with `requestApproval` button.
- Admin dashboard: table of users, approve/reject actions.
- Block main app routes until `isCallerApproved` is true (admins bypass).
- Clear status on logout.

---

## Related

| Topic | Path |
|---|---|
| Auth / RBAC | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
