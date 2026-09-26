# Motoko Code Validator & Linter Guide

IcFalcon includes an automated code validator and linter inspired by Python's `black` and `flake8` to guarantee cleanliness, consistent formatting, and architectural safety.

---

## 1. Quick Usage

```bash
# Run standard audit on backend/src
falcon audit code:motoko

# Short alias
falcon a:c:m

# Auto-format and fix whitespace, line endings & EOF newlines
falcon audit code:motoko --fix

# Strict mode (fails with exit code 1 on warnings for CI)
falcon audit code:motoko --strict

# Audit both backend/src AND backend/pkg
falcon audit code:motoko --all
```

---

## 2. Checks Enforced

### 1. Code Formatting & Consistency (`--fix` supported)
- **Trailing Whitespace**: Flags any trailing space or tab character on lines.
- **Line Endings (CRLF)**: Flags Windows `\r` carriage returns; enforces standard Unix `\n` line endings.
- **File Endings**: Enforces that all files end with a single newline at EOF.
- **Indentation**: Flags hard tab characters in indentation (standard is 2 spaces).

### 2. Architecture & Layering Rules
- **Direct Storage Import Ban**: `api/` files must NEVER import `storage/` directly. All reads/writes must pass through `services/`.
- **Pure Validators**: `validators/` modules must be pure calculation functions and cannot import `repositories/`, `storage/`, `services/`, or `ledger/`.
- **Downward Dependency Flow**: `storage/` and `repositories/` cannot import `services/` or `api/`.

### 3. Deprecated Library Ban
- Strictly forbids importing `mo:base`.
- Enforces modern `mo:core` (2.x) with contextual method calls (e.g. `map.get(k)`).

### 4. File Size Limits
- Emits a warning when any file exceeds **300 lines**.
- Recommends splitting large services into domain subdirectories with a facade module.

### 5. Naming Conventions
- Enforces `PascalCase.mo` for module files in `backend/src/` (except `main.mo` and `types.mo`).
- Enforces `*Storage.mo`, `*Repository.mo`, and `*Service.mo` suffixes.

### 6. Safety & Anti-Patterns
- **Upgrade Safety**: Enforces `persistent actor` in `main.mo` and flags risky manual `preupgrade` / `postupgrade` data serialization.
- **Trap vs Result**: Flags `Debug.trap` in public/shared functions (functions must return `Types.ApiResult` instead of trapping).

### 7. Compiler Typecheck
- Executes `moc --check` with resolved package dependencies (`mops sources`) to guarantee zero syntax or typecheck errors.

---

## 3. Pre-Flight Integration (`falcon p:check`)

The validator is wired into the first stage of `falcon p:check`:

```bash
falcon p:check --local
```

If any code style or architectural rule is violated, the pre-flight check terminates before compiling canisters or bundling the frontend, ensuring no flawed code reaches mainnet.
