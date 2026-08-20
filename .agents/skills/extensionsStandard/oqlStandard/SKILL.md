---
name: oqlStandard
description: >-
  Object Query Layer — expose canister collections as queryable entities with
  schema() and execute() endpoints. Optional analytics / natural-language queries.
---

# OQL — Object Query Layer

Expose stable collections as queryable entities for `schema()` and `execute()`
endpoints.

**Prerequisites:**
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md),
[`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md)

```bash
cd backend && mops add oql@0.5.0
```

---

## When to use

App stores structured data (Maps of records) that should be answerable in
natural language — "top customers", "revenue by region", "active projects".

Skip if the app has no analytics/query need.

---

## Setup

1. `mops add oql@0.5.0` in same batch as first `mo:oql/...` import.
2. Requires `moc >= 1.11`, `--default-persistent-actors`.
3. Import resolver modules **top-level** in the file declaring entities:
   - `mo:oql/Entity` — always
   - `mo:oql/MapEntity` (or List/Set/Array variant)
   - `mo:oql/RecordValue` + `<Type>Value` per field type

4. `include Expose(entities)` in `main.mo` — adds `schema` and `execute` only.

---

## Entity declaration

```motoko
import MapEntity "mo:oql/MapEntity";
import Entity "mo:oql/Entity";
import RecordValue "mo:oql/RecordValue";
import NatValue "mo:oql/NatValue";
import TextValue "mo:oql/TextValue";

let entities = [
  users.toEntity("user", "User", "id")
    .public_()
    .build(),
];
include Expose(entities);
```

Pick auth level per entity: `.controllerOnly()` (default, safe) or `.public_()`.

---

## Rules

- One entity per logical table.
- Non-transient stable collections only.
- Missing import errors (`field toEntity does not exist`) → add named resolver import.

---

## Related

| Topic | Path |
|---|---|
| Query reference | [`../queryingOqlStandard/SKILL.md`](../queryingOqlStandard/SKILL.md) |
| Layering | [`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md) |
