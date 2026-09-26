# IcFalcon Backend Architecture

IcFalcon enforces a clean, 4-tier modular architecture for Motoko canisters on the Internet Computer.

---

## 1. Directory Structure

```
backend/src/
├── main.mo                       # Canister actor entry point & dependency wiring
├── types.mo                      # Shared public domain types & ApiResult
├── config/Config.mo              # Global constants & environment parameters
├── api/v1/                       # Thin API mixins exposing Candid query/update methods
│   ├── Health.mo
│   ├── Auth.mo
│   └── <Feature>.mo
├── services/                     # Core business logic & authorization
│   ├── HealthService.mo
│   └── <Feature>Service.mo
├── repositories/                 # Storage query abstraction & entity mutations
│   └── <Feature>Repository.mo
├── storage/                      # Stable in-memory stores (Map/List)
│   └── <Feature>Storage.mo
├── validators/                   # Pure validation logic (returning ?Text)
│   └── <Feature>Validator.mo
└── middleware/                   # Authentication & caller validation
    └── Auth.mo
```

---

## 2. Layering Rules

```
┌────────────────────────────────────────┐
│             api/v1/ (Mixins)           │
└───────────────────┬────────────────────┘
                    │ Calls
                    ▼
┌────────────────────────────────────────┐
│               services/                │
└─────────┬───────────────────┬──────────┘
          │ Calls             │ Validates
          ▼                   ▼
┌──────────────────┐  ┌──────────────────┐
│  repositories/   │  │   validators/    │
└─────────┬────────┘  └──────────────────┘
          │ Accesses
          ▼
┌──────────────────┐
│     storage/     │
└──────────────────┘
```

| Layer | Allowed Imports | Forbidden Imports |
|---|---|---|
| `api/v1/` | `services/`, `types`, `middleware` | `storage/`, `repositories/` |
| `services/` | `repositories/`, `storage/`, `validators/`, `config/`, `types`, `pkg/` | `api/` |
| `repositories/` | `storage/`, `types`, `mo:core` | `services/`, `api/` |
| `storage/` | `types`, `mo:core` | `services/`, `api/`, `repositories/` |
| `validators/` | `types`, `config`, pure `mo:core` | `services/`, `storage/`, `repositories/`, `ledger/` |

> **Strict Rule**: `api/` must NEVER bypass `services/` to import `storage/` directly.

---

## 3. Persistent Actor & Upgrades

IcFalcon uses Motoko's **enhanced orthogonal persistence**:

```motoko
// backend/src/main.mo
import UserStorage "./storage/UserStorage";
import UserService "./services/UserService";

persistent actor self {
  // Persistent stores survive canister upgrades without serialization
  let users = UserStorage.createUserMap();

  // Transient services are reconstructed safely each upgrade
  transient let userService = UserService.create(users);
};
```

### Memory Rules
- **Persists**: User profiles, balances, transaction logs, configuration records.
- **Transient**: Service wrappers, in-memory caches, rate-limit counters.
- **Upgrade safety**: Deploys use `--wasm-memory-persistence keep` to retain up to 400 GiB of orthogonal memory.

---

## 4. Error Handling (`Types.ApiResult`)

Never use `Debug.trap` for user input or business errors. Always return structured results:

```motoko
// backend/src/types.mo
public type ApiResult<T> = {
  #ok : T;
  #err : Text;
};
```

### Validator Pattern
Validators are pure functions that return `?Text`:

```motoko
public func validateTitle(title : Text) : ?Text {
  if (Text.size(title) == 0) { ?("Title cannot be empty") }
  else if (Text.size(title) > 100) { ?("Title exceeds maximum length of 100") }
  else { null };
};
```

In services, handle validation with early returns:

```motoko
switch (ProductValidator.validateTitle(input.title)) {
  case (?err) { return #err(err) };
  case null ();
};
```
