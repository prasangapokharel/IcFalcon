---
name: dfinity-docs
description: >-
  Internet Computer Protocol essentials — parallel inter-canister calls,
  memory handling, in-flight limits, and ledger fee handling. Use when
  optimizing canister performance, handling concurrent calls, managing
  memory/upgrades, or implementing ICRC-1 transfers.
---

# Internet Computer Protocol — Essential Patterns

Compiled from official DFINITY documentation. These are protocol-level
constraints and patterns that differ from what most training data covers.

---

## 1. Parallel Inter-Canister Calls

**Source:** https://docs.internetcomputer.org/guides/canister-calls/parallel-inter-canister-calls/

### The Pattern

Multiple `await` calls can run concurrently when their results are independent:

```motoko
// Sequential — slow (2 RTT)
let balance1 = await Ledger.icrc1_balance_of(account1);
let balance2 = await Ledger.icrc1_balance_of(account2);

// Parallel — fast (1 RTT)
let (balance1, balance2) = await (
  Ledger.icrc1_balance_of(account1),
  Ledger.icrc1_balance_of(account2),
);
```

The tuple syntax dispatches both calls immediately and waits for both to
complete. Wall-clock time is the slowest call, not the sum.

### When to Use Parallel Calls

- Reading balances for multiple accounts
- Querying multiple ledgers
- Any set of calls where none depends on another's result

### When NOT to Use Parallel Calls

- One call needs the result of another (must be sequential)
- Calling the same canister 500+ times (see in-flight limit below)
- Order of execution matters for correctness

### Performance Impact

**Measured in IcFalcon's production canister:** converting 10 sequential ledger
queries to parallel reduced response time from ~2s to ~400ms — an 80% reduction.

---

## 2. In-Flight Call Limit

**Source:** https://docs.internetcomputer.org/guides/canister-calls/parallel-inter-canister-calls/#in-flight-call-limit

### The Hard Limit

**~500 in-flight calls** per canister pair. If canister A has 500 outstanding
calls to canister B, the 501st call is **rejected immediately**.

This is a protocol-level limit enforced by the execution layer, not a
configuration you can change.

### What "In-Flight" Means

A call is in-flight from the moment it's dispatched (`await` starts) until the
response arrives. Sequential calls stay under this limit naturally — only one
is active at a time. Parallel calls can blow through it.

```motoko
// This WILL hit the limit if users.size() > 500
let balances = await Array.map(users, func(u) {
  await Ledger.icrc1_balance_of(accountFor(u))  // all dispatched at once
});
```

### Handling Limit Errors

**Do not retry immediately.** The queue is still full right after the rejection.

```motoko
// WRONG — retries into the same full queue
switch (await Ledger.call()) {
  case (#ok(r)) { r };
  case (#err(_)) { await Ledger.call() };  // still rejected
};

// RIGHT — defer retry to a timer
switch (await Ledger.call()) {
  case (#ok(r)) { r };
  case (#err(_)) {
    pendingRetries.add(call);  // timer picks it up later
  };
};
```

### Batching Pattern

When the call count is unbounded, batch into chunks under 500:

```motoko
func processBatch(items: [Item], batchSize: Nat): async () {
  var i = 0;
  while (i < items.size()) {
    let end = Nat.min(i + batchSize, items.size());
    let chunk = Array.subArray(items, i, end - i);
    // Process chunk in parallel
    let results = await Array.map(chunk, func(item) {
      await ExternalCanister.process(item)
    });
    // Handle results before next batch
    i := end;
  };
};

// Safe: never more than 100 in-flight at once
await processBatch(allItems, 100);
```

---

## 3. Memory Handling

**Source:** https://docs.internetcomputer.org/concepts/protocol/execution/#memory-handling

### Orthogonal Persistence

The Internet Computer automatically persists all canister state to SSD. You do
**not** write explicit save/load calls — memory is "orthogonal" to code
execution.

| Memory Type | Survives Upgrade | Cleared By | Typical Use |
|---|---|---|---|
| **Heap** | No | Upgrade | Working state, cleared on upgrade |
| **Stable Memory** | Yes | Never (unless explicit) | Long-term state, upgrade-safe |

"Large state should be kept in stable memory directly to avoid the cost and
risk of copying it back and forth."

### Enhanced Orthogonal Persistence (Motoko)

With `--enhanced-orthogonal-persistence` (on by default in moc 0.10.0+), heap
variables marked `stable` or in a `persistent actor` survive upgrades without
manual serialization.

```motoko
actor {
  let users = Map.empty<Principal, User>();  // survives upgrade
  var nextId : Nat = 0;                      // survives upgrade
  transient var requestCount : Nat = 0;      // resets to 0 on upgrade
};
```

**Implication for IcFalcon:** every field in `storage/*.mo` is stable by default.
Timers, caches, and rate-limit counters that should reset are marked
`transient`.

### Capacity vs Performance

- **SSD storage** bounds total replicated state (subnet-wide)
- **RAM** affects access latency but not capacity
- Nodes use "high-end SSD storage and substantial RAM" to hold replicated state

A canister is limited by subnet SSD, not by a per-canister heap cap. In
practice, canisters hitting memory limits hit **instruction limits** or
**cycle exhaustion** first.

---

## 4. Ledger Fee Handling

**Source:** https://docs.internetcomputer.org/guides/digital-assets/ledgers/#fee-handling

### Query Fees at Runtime

**Never hardcode fees.** The ICP ledger's fee is 10_000 e8s today, but that's
a governance-controlled parameter and can change.

```motoko
let fee = await Ledger.icrc1_fee();  // query, costs nothing
```

For ICP specifically, `icrc1_fee()` is also replicated in `transfer_fee()` on
the legacy interface, returning `{ transfer_fee: { e8s: Nat64 } }`.

### Setting Fees in Transfers

The `fee` field in `TransferArg` is **not** optional in practice. Always set it:

```motoko
let args : TransferArg = {
  from_subaccount = ?mySubaccount;
  to = recipient;
  amount = 50_000_000;
  fee = ?10_000;              // explicit, not null
  memo = null;
  created_at_time = null;
};
```

Passing `fee = null` tells the ledger "use your default," which works, but
explicit is safer — if the ledger changes its default or has a bug, your call
still specifies what you intended.

### BadFee Error

If the fee you provide doesn't match the ledger's current fee, you get
`#BadFee({ expected_fee })`:

```motoko
switch (await Ledger.icrc1_transfer(args)) {
  case (#Err(#BadFee({ expected_fee }))) {
    // Retry with correct fee, or fail gracefully
    return #err("Fee mismatch. Expected: " # Nat.toText(expected_fee));
  };
  case (#Ok(blockIndex)) { blockIndex };
  case (#Err(e)) { /* handle other errors */ };
};
```

### Fee Deduction

Fees are deducted **from the sender's balance**, on top of the amount. So
transferring 1 ICP costs the sender 1.0001 ICP.

```motoko
let amount = 100_000_000;  // 1 ICP
let fee = 10_000;          // 0.0001 ICP
let required = amount + fee;

if (balance < required) {
  return #err("Insufficient funds");
};
```

The ledger returns `#InsufficientFunds({ balance })` if the sender cannot cover
amount + fee. That `balance` field is useful for telling the user exactly how
much they have.

### ICRC-2 Fees

Both `icrc2_approve` and `icrc2_transfer_from` also require a fee. The approve
fee is deducted when the approval is granted; the transfer_from fee is deducted
when the spender pulls the funds.

```motoko
// Approve: caller pays fee now
let approveResult = await Ledger.icrc2_approve({
  from_subaccount = null;
  spender = { owner = dexCanister; subaccount = null };
  amount = 100_000_000;
  fee = ?10_000;  // deducted from caller's balance immediately
  expected_allowance = null;
  expires_at = null;
  memo = null;
  created_at_time = null;
});

// TransferFrom: spender's tx pays this fee, not the original owner
let transferResult = await Ledger.icrc2_transfer_from({
  spender_subaccount = null;
  from = { owner = userPrincipal; subaccount = null };
  to = { owner = dexCanister; subaccount = null };
  amount = 100_000_000;
  fee = ?10_000;  // deducted when this call executes
  memo = null;
  created_at_time = null;
});
```

### Double-Fee Trap

A common bug: transferring tokens *to* a pool, then the pool transferring them
*out* means **two ledger fees** are deducted.

```motoko
// User -> Pool: ledger deducts fee, pool receives (amount - fee)
await Ledger.icrc1_transfer({
  to = poolAccount;
  amount = 100_000_000;
  fee = ?10_000;
});
// Pool now has 99_990_000 (100M - 10k)

// Pool -> User: ledger deducts fee again, user receives (99_990_000 - 10_000)
await Ledger.icrc1_transfer({
  to = userAccount;
  amount = 99_990_000;
  fee = ?10_000;
});
// User receives 99_980_000

// Total fees paid: 20_000 (0.0002 ICP)
```

This is why IcFalcon's `SwapService.mo:316` explicitly calculates
`actualReceived = transferAmount - tokenOutFee` — the pool withdrew
`amountOut - fee`, then the final transfer to the user deducts fee *again*.

### Best Practices

1. **Query `icrc1_fee()` at runtime** — never assume 10_000.
2. **Set `fee` explicitly** in every transfer arg.
3. **Validate balance ≥ amount + fee** before calling.
4. **Handle `#BadFee`** by retrying with `expected_fee` or failing gracefully.
5. **Account for double fees** when funds pass through an intermediary.
6. **Use the returned `blockIndex`** as the ground-truth receipt, not the
   success variant alone.

---

## 5. Combining These Patterns

### Parallel Balance Checks with Fee Validation

```motoko
// Fetch all three in parallel (1 RTT instead of 3)
let (balance, feeIn, feeOut) = await (
  Ledger.icrc1_balance_of(userAccount),
  LedgerIn.icrc1_fee(),
  LedgerOut.icrc1_fee(),
);

let required = amountIn + feeIn;
if (balance < required) {
  return #err("Need " # Nat.toText(required) # ", have " # Nat.toText(balance));
};
```

### Batched Transfers Under In-Flight Limit

```motoko
func distributeToAll(recipients: [Principal], amount: Nat): async [Result] {
  let results = Buffer.Buffer<Result>(recipients.size());
  let batchSize = 400;  // safely under 500 limit
  var i = 0;

  while (i < recipients.size()) {
    let end = Nat.min(i + batchSize, recipients.size());
    let batch = Array.slice(recipients, i, end);

    // Dispatch batch in parallel
    let batchResults = await Array.map(batch, func(p) {
      await Ledger.icrc1_transfer({
        to = { owner = p; subaccount = null };
        amount;
        fee = ?10_000;
        from_subaccount = null;
        memo = null;
        created_at_time = null;
      })
    });

    for (r in batchResults.vals()) { results.add(r) };
    i := end;
  };

  Buffer.toArray(results)
};
```

### Upgrade-Safe Retry Queue

```motoko
actor {
  // Persists across upgrades
  let pendingCalls = List.empty<CallData>();

  // Resets on upgrade — timer must be re-registered
  transient var timerId : Nat = 0;

  system func timer(setGlobalTimer: Nat64 -> ()) : async () {
    // Re-register timer after upgrade
    timerId := setGlobalTimer(systemTimerNext());

    // Retry pending calls (spread retries to avoid hitting in-flight limit)
    for (call in pendingCalls.values()) {
      switch (await externalCanister.retry(call)) {
        case (#ok(_)) { pendingCalls.remove(call.id) };
        case (#err(_)) { /* keeps retrying next tick */ };
      };
    };
  };
};
```

---

## 6. Quick Reference

| Concept | Limit / Rule |
|---|---|
| In-flight calls per canister pair | ~500 |
| Heap memory across upgrade | Cleared unless `stable` |
| Stable memory across upgrade | Persists |
| ICP transfer fee (current) | 10_000 e8s (0.0001 ICP) |
| Fee query cost | 0 cycles (query call) |
| Parallel call latency | max(call1, call2, ...), not sum |
| Sequential call latency | sum(call1 + call2 + ...) |
| Timer state across upgrade | Lost — must re-register |

---

## 7. Further Reading

- Parallel calls guide: https://docs.internetcomputer.org/guides/canister-calls/parallel-inter-canister-calls/
- Memory handling: https://docs.internetcomputer.org/concepts/protocol/execution/#memory-handling
- In-flight limit: https://docs.internetcomputer.org/guides/canister-calls/parallel-inter-canister-calls/#in-flight-call-limit
- Ledger fee handling: https://docs.internetcomputer.org/guides/digital-assets/ledgers/#fee-handling
- ICRC-1 standard: https://github.com/dfinity/ICRC-1
- Token transfer sample: https://docs.internetcomputer.org/references/samples/motoko/token_transfer/
