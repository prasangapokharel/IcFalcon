# Money, Payments & ICPay Integration

IcFalcon provides a hardened money layer for building financial applications on the Internet Computer.

---

## 1. Safety Principles

All financial logic follows strict non-negotiable rules:
1. **Never hand-roll subaccounts**: Always use `subaccount.fromPrincipal(caller)` for deterministic 32-byte subaccounts.
2. **Pre-flight Fee Check**: Always verify `amount + fee <= balance` before initiating a ledger transfer.
3. **Dual Transaction Records**: Record two immutable ledger rows (debit from sender, credit to recipient) per internal transfer.
4. **Idempotency**: Use unique client transfer IDs to prevent double-spends during network timeouts.
5. **Caller Purity**: Use the authenticated caller (`caller`) as the source of funds; never accept a sender principal as a function parameter.

---

## 2. Wallet & Subaccount Architecture

```
User Principal (e.g. 2vxsx-fae)
      │
      ▼
subaccount.fromPrincipal(caller)  ──>  Deterministic [Nat8; 32]
      │
      ▼
ICRC-1 Account: { owner = canisterPrincipal; subaccount = ?subaccount }
      │
      ▼
Deposit Address on Ledger (ICP / ckBTC)
```

### Deriving User Deposit Accounts

```motoko
import Subaccount "mo:pkg/subaccount/subaccount";
import Principal "mo:core/Principal";

public func getUserAccount(canisterId : Principal, userPrincipal : Principal) : {
  owner : Principal;
  subaccount : ?[Nat8];
} {
  {
    owner = canisterId;
    subaccount = ?Subaccount.fromPrincipal(userPrincipal);
  };
};
```

---

## 3. Safe Transfer Pattern

```motoko
public func sendTokens(
  service : TransferService,
  caller : Principal,
  to : Principal,
  amount : Nat
) : async Types.ApiResult<Nat> {
  let fee = Config.DEFAULT_FEE;
  let balance = await getBalance(service, caller);

  // 1. Balance check including fee
  if (amount + fee > balance) {
    return #err("Insufficient balance to cover amount and transaction fee");
  };

  // 2. Initiate ICRC-1 transfer
  let transferResult = await Ledger.transfer({
    from_subaccount = ?Subaccount.fromPrincipal(caller);
    to = { owner = to; subaccount = null };
    amount;
    fee = ?fee;
    memo = null;
    created_at_time = ?Time.now();
  });

  switch (transferResult) {
    case (#Ok(txIndex)) {
      // 3. Record transaction in local history
      TxStore.recordTransfer(service.txStore, caller, to, amount, txIndex);
      #ok(txIndex);
    };
    case (#Err(ledgerErr)) {
      #err(debug_show(ledgerErr));
    };
  };
};
```

---

## 4. ICPay Controller Governance

For decentralized production canisters, manage controllers via **[icpay.app](https://icpay.app)**:
- Add deployer principals to your ICPay team or multisig canister settings.
- Avoid deploying with a single ephemeral developer key.
- Verify controller status:
  ```bash
  falcon c:info
  ```
