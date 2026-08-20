---
name: aiActionsStandard
description: >-
  AI-safe money actions — propose vs execute, human confirm, idempotency, rate
  limits. Load before scaffolding or modifying transfer/wallet endpoints for AI.
---

# AI Actions Standard

## Purpose

Guardrails so AI agents scaffold wallet features without unsafe ledger calls.

## When to use

- Adding or changing `proposeTransfer` / `executeTransfer`
- AI-generated send flows
- Any custodial transfer endpoint

**Always load with:** [`../../motokoStandard/ledgerIntegrationStandard/SKILL.md`](../../motokoStandard/ledgerIntegrationStandard/SKILL.md) and [`../financeStandard/transferStandard/SKILL.md`](../financeStandard/transferStandard/SKILL.md).

## Allowed actions

| Action | Endpoint | Ledger call |
|---|---|---|
| Register wallet | `registerWallet` | No |
| Balance | `getBalance` | Yes (read) |
| Deposit address | `depositInfo` | No |
| **Propose** transfer | `proposeTransfer` | Read balance + fee only |
| **Execute** transfer | `executeTransfer` | `icrc1_transfer` |
| History | `listTransactions` | No |

## Forbidden

- Calling `executeTransfer` from AI without human confirm in UI
- Skipping `transferId` idempotency key
- Ledger calls from `api/` or `repositories/`
- Hardcoded fees

## Pattern

```
1. Client generates transferId (UUID) once per send intent
2. proposeTransfer(transferId, to, amount) → preview (fee, totalDebit)
3. Human confirms in UI
4. executeTransfer(same transferId, to, amount) → ledger + tx rows
```

Idempotency:

- `#completed` + same `transferId` → replay receipt (`#ok`)
- `#pending` + same `transferId` → `#err` code `409` conflict
- Rate limit on `executeTransfer` only (`429` when exceeded)

## Rules

- `proposeTransfer` must not insert pending rows or call `icrc1_transfer`
- `executeTransfer` inserts `#pending` before await, removes on failure
- Internal transfer = two tx rows (see transferStandard)
- Test with a **second identity**

## Related

| Task | Skill |
|---|---|
| Transfers | [`../financeStandard/transferStandard/SKILL.md`](../financeStandard/transferStandard/SKILL.md) |
| Layering | [`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md) |
| Frontend confirm | [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
