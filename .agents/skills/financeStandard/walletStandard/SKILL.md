---
name: walletStandard
description: >-
  Custodial wallet — derive accounts, deposit addresses, balance reads. Use when
  scaffolding wallet features, deposit UI, or registering users for on-chain funds.
---

# Wallet Standard

## Purpose

Teach agents how to compose IcFalcon hub packages for custodial wallets.

## When to use

- New wallet / deposit feature
- Deriving per-user ICRC accounts
- Multi-token support (ICP, ckBTC, custom ICRC)

## Packages

```bash
falcon add pkg subaccount
falcon add pkg ledger
falcon add pkg icrc1
falcon add pkg wallet
```

| Package | Import |
|---|---|
| `subaccount` | `mo:pkg/subaccount/subaccount` |
| `ledger` | `mo:pkg/ledger/ledger` |
| `icrc1` | `mo:pkg/icrc1/icrc1` |
| `wallet` | `mo:pkg/wallet/wallet` |

## Pattern

```
api/v1/Wallet.mo → WalletService → mo:pkg/wallet
```

Hub pkgs are pure logic. Only `WalletService` awaits `icrc1_balance_of`.

```motoko
import Ledger "mo:pkg/ledger/ledger";
import Wallet "mo:pkg/wallet/wallet";

let token = Ledger.icpTokenRef(ledgerId);
let account = Wallet.deriveAccount(canisterId, user, token);
let deposit = Wallet.depositInfo(account);
// Expose deposit.icrcAccount AND deposit.accountIdHex to frontend

// Balance for spend decisions (service layer only):
let balance = await ledger.icrc1_balance_of(Wallet.toIcrcAccount(account));
```

Multi-token: swap `token` only — same `deriveAccount` for ICP and ckBTC.

```motoko
import CkBtc "mo:pkg/ckbtc/ckbtc";
let ckToken = CkBtc.tokenRef(ckbtcLedgerId);
```

## Rules

- Owner = **canister**, subaccount = `SubaccountPkg.fromPrincipal(user)`
- Ledger is source of truth — never store balance as authoritative state
- No ledger calls from `api/` or `repositories/`
- No `async` in hub packages
- Funds can exist on ledger before user row exists in your map

Ledger hazards (double-credit, address formats, fees): read
[`../../motokoStandard/ledgerIntegrationStandard/SKILL.md`](../../motokoStandard/ledgerIntegrationStandard/SKILL.md).

## Related

| Task | Skill |
|---|---|
| Send tokens | [`../transferStandard/SKILL.md`](../transferStandard/SKILL.md) |
| Tx history | [`../transactionStandard/SKILL.md`](../transactionStandard/SKILL.md) |
| Layering | [`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md) |
