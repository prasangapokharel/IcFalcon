---
name: errorHandlingStandard
description: >-
  IcFalcon Motoko error handling — ApiResult, validators, early returns, ledger
  and call_error, traps vs results. Read before writing any service or API endpoint.
---

# IcFalcon — Error Handling

Every user-facing failure returns **`Types.ApiResult<T>`** with a structured
`ApiError`. Expected failures never trap. Traps are for programmer bugs only.

---

## Type system

`mo:pkg/errors/result`:

```motoko
public type ApiError = { code : Nat32; message : Text };
public type ApiResult<T> = { #ok : T; #err : ApiError };

Result.ok(value)
Result.err(Result.badRequest, "Message")
Result.err(Result.unauthorized, "Unauthorized")
Result.err(Result.notFound, "Wallet not registered")
Result.err(Result.conflict, "Transfer in flight")
Result.err(Result.tooManyRequests, "Rate limit exceeded")
```

Codes: `400` badRequest · `401` unauthorized · `403` forbidden · `404` notFound
· `409` conflict · `429` tooManyRequests

`backend/src/types.mo` re-exports these as `Types.ApiResult<T>`.

---

## Layer responsibilities

```
API (api/v1/)     → pass through ApiResult; no business rules
Service           → validate, authorize, return #err or #ok
Repository        → data access only; returns ?T or ()
Validator         → pure func … : ?Text  (Some msg = invalid)
Storage           → no validation
```

| Layer | Returns | Must not |
|---|---|---|
| `api/v1/*.mo` | `async Types.ApiResult<T>` | Read storage, trap on bad input |
| `services/*.mo` | `Types.ApiResult<T>` or `async` | Skip validators |
| `validators/*.mo` | `?Text` | Call ledger or return `#err` |
| `repositories/*.mo` | `?Record`, `()` | Return `ApiResult` |

---

## Anonymous caller — reject on all mutating paths

Internet Identity and fund-moving endpoints must reject the anonymous principal
(`2vxsx-fae`). Use `mo:pkg/principal/caller`:

```motoko
import Caller "mo:pkg/principal/caller";

switch (Caller.requireAuth(caller)) {
  case (?message) { return Result.err(Result.unauthorized, message) };
  case (null) {};
};
```

`Caller.requireAuth` uses `Principal.isAnonymous`. Apply on **every** update that
reads or moves user data. Resolve `caller` via `MiddlewareAuth.effectiveCaller`
in the API — never trust a user-supplied principal for fund paths.

---

## API pattern — thin mixin

```motoko
public shared ({ caller }) func executeTransfer(...) : async Types.ApiResult<...> {
  await TransferService.execute(
    transferService,
    MiddlewareAuth.effectiveCaller(mwConfig, caller),
    transferId, toPrincipal, amount,
  );
};
```

- API does not wrap service results — service already returns `ApiResult`.
- `shared query` for read-only; `shared` (update) for mutations.
- **`try/catch` cannot be used in `shared query`** — queries are not async;
  wrap inter-canister calls only in update/shared async functions.

---

## Service pattern — early return

```motoko
switch (WalletValidator.validateAmount(amount)) {
  case (?message) { return Result.err(Result.badRequest, message) };
  case (null) {};
};
switch (UserRepo.findByPrincipal(users, caller)) {
  case (null) { return Result.err(Result.notFound, "User not found") };
  case (?user) { /* use user */ };
};
```

### Option shorthand (`??`)

For simple unwrap-or-return, prefer `??` (see
[`writingMotokoStandard/references/control-flow.md`](../motokoStandard/writingMotokoStandard/references/control-flow.md)):

```motoko
// Readable when the right-hand side is a plain return:
let user = UserRepo.findByPrincipal(users, caller)
  ?? return Result.err(Result.notFound, "User not found");
```

Use `switch` when the `?` arm needs transformation or multiple branches.

### Rules

| Rule | Example |
|---|---|
| Fail fast before ledger `await` | `return Result.err(...)` |
| Validators return `?Text` | `null` = valid |
| Ledger **variant** errors → `#err` | `Transfer.mapResult(raw)` |
| Ledger **call** errors → `try/catch` | See below |
| Never trap for user input | `"Invalid amount"` not `Debug.trap` |
| Capture `caller` before `await` on fund paths | Avoid stale identity |

---

## Validator pattern

```motoko
module {
  public func validate(amount : Nat) : ?Text {
    if (amount == 0) return ?"Amount must be greater than zero";
    null;
  };
};
```

| Return | Meaning |
|---|---|
| `null` | Valid |
| `?Text` | Invalid — user-facing message |

---

## Ledger errors — two failure modes

### 1. Call succeeds — ledger returns a variant (`#Ok` / `#Err`)

Map with pkg helpers — never leak raw blobs:

```motoko
let raw = await ledger.icrc1_transfer(args);
let result = Transfer.mapResult(raw);
switch (result) {
  case (#err({ message })) {
    TransactionRepo.remove(store, transferId);
    Result.err(Result.badRequest, message);
  };
  case (#ok({ blockIndex })) { /* complete */ };
};
```

**Do not** pre-flight balance read before transfer — racy and wastes cycles.
The ledger `#InsufficientFunds` variant is authoritative.

### 2. Call fails — `#call_error` (queue full, freezing threshold, etc.)

The `await` itself can throw `Error` with code `#call_error`. Wrap fund-moving
`await` in `try/catch`:

```motoko
import Error "mo:core/Error";

let result = try {
  let raw = await ledger.icrc1_transfer(args);
  Transfer.mapResult(raw);
} catch (e) {
  TransactionRepo.remove(store, transferId);
  return Result.err(
    Result.badRequest,
    "Ledger call failed: " # Error.message(e),
  );
};
```

Apply to balance reads and fee reads on critical paths too. On execute paths,
clean up `#pending` rows inside `catch` before returning.

Reference: `TransferService.execute` in `backend/src/services/TransferService.mo`.

---

## Rate limiting

```motoko
if (not RateLimit.allow(service.rateLimit, caller, max, window)) {
  return Result.err(Result.tooManyRequests, "Transfer rate limit exceeded");
};
```

---

## Traps — when allowed

| OK to trap | Not OK |
|---|---|
| `assert false` in tests | Invalid username from user |
| Unreachable arm after validation | Insufficient funds |
| Programmer invariant | Room / wallet not found |

`try/catch` is for **inter-canister call failures**, not for catching your own
traps. Prefer `ApiResult` for expected failures.

---

## Message conventions

| Do | Don't |
|---|---|
| `"Wallet not registered"` | `"Error 404"` |
| `"Transfer in flight"` | `"fail"` |
| `"Ledger call failed: " # Error.message(e)` | Raw debug prints |
| Stable messages when frontend matches on text | Silent text changes |

---

## Frontend contract

Candid maps `#ok` / `#err` to a variant. TypeScript checks `data.ok` / `data.err`
in `frontend/services/client.ts` and `call()` helpers.

---

## Checklist for new endpoints

- [ ] Service returns `Types.ApiResult<T>` for all failure paths
- [ ] Input validated via `validators/` (`?Text`)
- [ ] `Caller.requireAuth` on mutating endpoints (reject anonymous)
- [ ] `caller` from middleware — not user-supplied principal on fund paths
- [ ] Rate limit if mutating user action
- [ ] Ledger variant errors mapped (`Transfer.mapResult`, etc.)
- [ ] **`try/catch` around `await` ledger / inter-canister calls** (`#call_error`)
- [ ] `#pending` row removed on transfer failure or `catch`
- [ ] API mixin only delegates
- [ ] Test at least one `#err` path in `backend/testing/`

---

## Related skills

| Topic | Path |
|---|---|
| Layering | [`layeringStandard/SKILL.md`](../layeringStandard/SKILL.md) |
| Endpoints | [`endpointsStandard/SKILL.md`](../endpointsStandard/SKILL.md) |
| Ledger hazards | [`motokoStandard/ledgerIntegrationStandard/SKILL.md`](../motokoStandard/ledgerIntegrationStandard/SKILL.md) |
| Option / `??` | [`motokoStandard/writingMotokoStandard/SKILL.md`](../motokoStandard/writingMotokoStandard/SKILL.md) |
| Testing | [`testingStandard/SKILL.md`](../testingStandard/SKILL.md) |
