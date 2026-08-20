---
name: queryingOqlStandard
description: >-
  Quick reference for querying an OQL canister — schema(), execute(), JSON query
  syntax, filters, pagination. Load when calling OQL endpoints via dfx/icp CLI.
---

# Querying OQL

Read-only reference for `schema()` and `execute()` on OQL-enabled canisters.

**Prerequisite:** [`../oqlStandard/SKILL.md`](../oqlStandard/SKILL.md) — backend must expose OQL first.

---

## Methods

| Method | Type | Returns |
|---|---|---|
| `schema()` | query | JSON catalogue of entities, fields, edges |
| `execute(qJson)` | query | Matching rows for JSON-encoded query |

---

## CLI calls

```bash
dfx canister call app schema '()' --query
dfx canister call app execute '("<json-query>")' --query
```

Escape quotes in JSON: `{"start":"customer","limit":3}` →
`'("{\"start\":\"customer\",\"limit\":3}")'`

---

## Recipe

1. Call `schema()` once — cache for session.
2. Map user question to entity + fields from schema.
3. Build JSON query with `start`, `where`, `orderBy`, `limit`, `offset`.
4. Parse Candid result rows by cell `name`.
5. If `hasMore`, page with `offset`.

---

## Query shape

```json
{
  "start": "order",
  "where": { "field": "status", "op": "eq", "value": "paid" },
  "orderBy": [{ "field": "createdAt", "dir": "desc" }],
  "limit": 20,
  "offset": 0
}
```

Cross-entity: dotted paths for forward edges; reverse one-to-many needs `in` filter
with parent keys from a prior query.

---

## Errors

No error envelope — failed queries trap. Re-read schema, fix query, retry.

---

## Related

| Topic | Path |
|---|---|
| OQL setup | [`../oqlStandard/SKILL.md`](../oqlStandard/SKILL.md) |
