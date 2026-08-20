---
name: transactionStandard
description: >-
  Transaction history and deposit sync index. Use when recording tx rows,
  building history UI, or debugging double-credit reconciliation.
---

# Transaction Standard

## Purpose

Teach agents how to index ledger activity — not replace it.

## When to use

- `TransactionRepository` / `TxStore` design
- History API (`txHistory` query)
- Deposit sync reconciliation

## Packages

```bash
falcon add pkg transaction ledger
```

## Pattern

```
TransferService → Transfer.recordsForTransfer → Transaction.insert
DepositService  → sync formula → Transaction.insert (#deposit)
api/v1/Wallet.mo → query txHistory (no ledger calls)
```

```motoko
import Transaction "mo:pkg/transaction/transaction";

Transaction.insert(store, {
  id = transferId;
  user = caller;
  kind = #transferOut;
  amount; fee;
  token = account.token;
  status = #pending;  // before ledger await
  createdAt = Time.now();
  // ...
});
```

Pkg helpers: `insert`, `getByTransferId`, `listByUser` (scan — add repo index at scale).

## Rules

- TxStore is an **index** — never sum rows as spendable balance
- `#pending` before await → `#completed` with `blockIndex` or `#failed` + verify ledger
- `TokenRef` on every row for multi-token apps
- At scale: paginate in `repositories/`, use `mo:pkg/indexer` — not raw pkg scan
- Deposit sync formula and double-credit hazards: read
  [`../../motokoStandard/ledgerIntegrationStandard/SKILL.md`](../../motokoStandard/ledgerIntegrationStandard/SKILL.md)

## Related

| Task | Skill |
|---|---|
| Transfers | [`../transferStandard/SKILL.md`](../transferStandard/SKILL.md) |
| Wallet | [`../walletStandard/SKILL.md`](../walletStandard/SKILL.md) |
