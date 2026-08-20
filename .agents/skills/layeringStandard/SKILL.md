---
name: layeringStandard
description: >-
  IcFalcon backend layering rules — api → services → repositories → storage.
  Read before adding any Motoko module or endpoint.
---

# IcFalcon — Layering

Strict one-way data flow. No shortcuts.

```
api/v1/ → services/ → repositories/ → storage/
```

## Rules

| Layer | May call | Must not |
|---|---|---|
| `api/v1/` | services, middleware | repositories, storage, business logic |
| `services/` | repositories, validators, pkg/, ledger | skip repository layer |
| `repositories/` | storage, types | validators with side effects, ledger |
| `storage/` | types, mo:core | business logic |
| `validators/` | pure checks only | storage, ledger |
| `pkg/` | mo:core only | backend/src layers |

## Paths

```
backend/src/
├── main.mo
├── types.mo
├── api/v1/<Name>.mo
├── services/<Name>Service.mo
├── repositories/<Name>Repository.mo
├── storage/<Name>Storage.mo
├── validators/<Name>Validator.mo
├── migrations/
├── middleware/Auth.mo
└── config/Config.mo

backend/pkg/          # shared via mo:pkg/...
```

## Scaffold fast

```bash
falcon m:f Order    # creates all layers + wires main.mo
```

Templates: [`ops/templates/feature/`](../../../ops/templates/feature/)

## Related

| Skill | Path |
|---|---|
| Coding standard | [`codingStandard/SKILL.md`](../codingStandard/SKILL.md) |
| Integration | [`integrationStandard/SKILL.md`](../integrationStandard/SKILL.md) |
| Errors | [`errorHandling/SKILL.md`](../errorHandlingStandard/SKILL.md) |
| Migrations | [`migration/SKILL.md`](../migrationStandard/SKILL.md) |
