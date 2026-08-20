---
name: transferStandard
description: >-
  ICRC transfers — fee reserve, idempotency, two-row records. Use when building
  TransferService or sending ICP/ICRC from a custodial wallet.
---

# Transfer Standard

## Purpose

Teach agents how to send tokens safely using hub `transfer` + `transaction` pkgs.

## When to use

- `TransferService.send` implementation
- Internal user-to-user transfers
- ICRC-2 approve flows (use `icrc2` pkg, same layering)

## Packages

```bash
falcon add pkg transfer
falcon add pkg transaction
falcon add pkg icrc1
```

Prerequisite: [`walletStandard`](../walletStandard/SKILL.md) (custodial account).

## Pattern

```
api/v1/Wallet.mo → TransferService → mo:pkg/transfer
                                   → await ledger.icrc1_transfer (service only)
```

```motoko
import Transfer "mo:pkg/transfer/transfer";

// 1. Idempotency check (TxStore) — see transactionStandard
// 2. Validate + build (pure)
switch (Transfer.validateRequest(req, balance, fee)) {
  case (?msg) { return #err(msg) };
  case (null) {};
};
let args = Transfer.buildTransferArgs(req, fee);

// 3. Await ledger ONCE in service
let raw = await ledger.icrc1_transfer(args);
let result = Transfer.mapResult(raw);

// 4. Two rows for internal transfers
let rows = Transfer.recordsForTransfer(req, result, fee, ?recipient, Time.now());
```

Fee: read `await ledger.icrc1_fee()` when possible. Validate `amount + fee <= balance`.

## Rules

- Idempotency in **TransferService** — check `transferId` in TxStore before await
- Write `#pending` tx row **before** `icrc1_transfer` await
- Internal transfer = **two** `TxRecord` rows (sender + recipient)
- Guard self-transfers
- Test with a **second identity**
- AI may propose transfers; human confirms before execute (Phase 2)

Fee, failure, and double-credit hazards: read
[`../../motokoStandard/ledgerIntegrationStandard/SKILL.md`](../../motokoStandard/ledgerIntegrationStandard/SKILL.md).

## Related

| Task | Skill |
|---|---|
| Wallet setup | [`../walletStandard/SKILL.md`](../walletStandard/SKILL.md) |
| Tx records | [`../transactionStandard/SKILL.md`](../transactionStandard/SKILL.md) |
| Auth | [`../../motokoStandard/authorizationStandard/SKILL.md`](../../motokoStandard/authorizationStandard/SKILL.md) |
