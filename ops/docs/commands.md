# Commands Reference

Everything runs via the global CLI: `falcon <command> [--local] [args]`

- **Mainnet by default**: Commands deploy and query mainnet without flags.
- **Local replica**: Append `--local` for local development replica.
- **Install once**: `./ops/install.sh` (symlinks `falcon` to `~/.local/bin/falcon`).

---

## Quick Reference Table

| Category | Command | Alias | What It Does |
|---|---|---|---|
| **Setup** | `falcon setup:init` | `falcon s:init` | Install dependencies, shadcn components, build, start dev server |
| | `falcon replica:start` | `falcon r:start` | Start local IC replica (`dfx start --background`) |
| | `falcon replica:stop` | `falcon r:stop` | Stop local IC replica |
| **Audit** | `falcon audit:motoko` | `falcon a:c:m` / `falcon audit code:motoko` | Audit Motoko code style, layering & syntax (black-style) |
| | `falcon audit code:motoko --fix` | `falcon a:c:m -f` | Auto-fix whitespace, CRLF line endings, and EOF newlines |
| | `falcon audit code:motoko --all` | `falcon a:c:m -a` | Audit both `backend/src` and `backend/pkg` |
| | `falcon audit code:motoko --strict`| `falcon a:c:m -s` | Strict mode (treat warnings as errors for CI) |
| **Backend** | `falcon backend:test` | `falcon b:test` | Run Motoko unit tests + build canister |
| | `falcon backend:build` | `falcon b:build` | Compile Motoko canister Wasm |
| | `falcon backend:deploy` | `falcon b:deploy` | Build and deploy canister with upgrade mode |
| | `falcon backend:hash` | `falcon b:hash` | Show module hash and canister info |
| | `falcon backend:logs` | `falcon b:logs` | View canister execution logs |
| **Production** | `falcon prod:check` | `falcon p:check` | Validate skills + audit Motoko code + build backend + frontend |
| | `falcon prod:ship` | `falcon p:ship` | Deploy backend to network + build frontend |
| **Skills** | `falcon skills:validate` | `falcon sk:validate` | Validate AI skills structure, frontmatter & links |
| **Packages** | `falcon pkg:list` | `falcon p:list` | List all available packages in the `icp-hub` registry |
| | `falcon pkg:add <name>` | `falcon add pkg <name>` / `falcon a:p <name>` | Install a package from `icp-hub` into `backend/pkg/` |
| | `falcon pkg:installed` | `falcon p:ls` | List installed packages and lockfile status |
| | `falcon pkg:push <name>` | `falcon p:push` | Publish local package to registry |
| **Scaffold** | `falcon make:feature <Name>` | `falcon m:f <Name>` | Scaffold full domain feature (backend + frontend) |
| **Canister** | `falcon canister:status` | `falcon c:status` | Query canister operational status and memory |
| | `falcon canister:ping` | `falcon c:ping` | Run health ping query |
| | `falcon canister:id` | `falcon c:id` | Show canister ID |
| | `falcon canister:call <method>` | `falcon c:call` | Call canister Candid method |
| **Cycles** | `falcon cycles:balance` | `falcon y:bal` | Check canister cycles balance |
| | `falcon cycles:address` | `falcon y:addr` | Display cycles ledger account ID |
| **Users** | `falcon users:count` | `falcon u:count` | Status query of registered users and counters |
| **Frontend** | `falcon frontend:dev` | `falcon f:dev` | Launch Next.js local development server |
| | `falcon frontend:build` | `falcon f:build` | Static export build for asset canister hosting |

---

## Detailed Command Guides

### 1. Code Audit & Linting (`falcon audit code:motoko`)

Brings Python `black` and `flake8` consistency to Motoko.

```bash
falcon audit code:motoko            # audit backend/src
falcon a:c:m                        # short alias
falcon audit code:motoko --fix      # auto-fix formatting issues
falcon audit code:motoko --strict   # fail on warnings (CI mode)
falcon audit code:motoko --all      # audit src and pkg folders
```

**Checks enforced:**
- Formatting: No trailing whitespace, no Windows CRLF (`\r`), single newline at EOF.
- Layering: `api/` must NEVER import `storage/` directly. `validators/` must be pure.
- Deprecations: Strict ban on legacy `mo:base` (enforces `mo:core`).
- File size: Warning when any file exceeds 300 lines (prompting domain module splits).
- Safety: `persistent actor` in `main.mo`, no `Debug.trap` in public/shared endpoints.
- Compiler check: Direct `moc --check` syntax and type validation.

---

### 2. Package Management (`icp-hub`)

Install reusable, audited Motoko modules with zero boilerplate:

```bash
# List all 65+ packages
falcon p:list

# Install packages
falcon add pkg universe    # Multi-canister event mesh ("Kafka for Motoko")
falcon add pkg wallet      # Custodial wallet & balance manager
falcon add pkg transfer    # ICRC transfer helpers
falcon add pkg openai      # AI chat & payload builder
falcon add pkg stripe      # Stripe checkout integration

# List installed packages
falcon p:ls
```

Lockfile is tracked in `backend/icp.pkg`.

---

### 3. Scaffold Full Feature (`falcon m:f <Name>`)

Scaffolds a complete Laravel-style full-stack feature in seconds:

```bash
falcon m:f Order
```

**Automatically creates and wires:**
- Backend:
  - `backend/src/types.mo` (record types and `ApiResult`)
  - `backend/src/storage/OrderStorage.mo`
  - `backend/src/repositories/OrderRepository.mo`
  - `backend/src/validators/OrderValidator.mo`
  - `backend/src/services/OrderService.mo`
  - `backend/src/api/v1/Order.mo`
  - Wires mixin and storage into `backend/src/main.mo`
- Frontend:
  - `frontend/src/services/orderService.ts`
  - `frontend/src/components/features/OrderPanel.tsx`

---

### 4. Pre-Flight Checks & Deployment

```bash
# Complete pre-flight validation (local)
falcon p:check --local

# Complete pre-flight validation (mainnet)
falcon p:check

# Deploy to mainnet (prompts TTY confirmation for safety)
falcon b:deploy
falcon p:ship
```

`falcon p:check` runs four automated stages:
1. `validate-skills.sh`: Validates all AI agent skills, frontmatter, and links.
2. `validate-code.sh`: Runs the Motoko code audit and linter.
3. Canister build: Compiles Motoko wasm with persistent memory.
4. Next.js export: Generates optimized static HTML/JS for asset canister.

---

### 5. Canister Inter-Communication

```bash
# Health check
falcon c:ping --local

# Call query method
falcon c:call status --local

# Call update method with Candid arguments
falcon c:call createProduct '("Laptop", 1200)' --update --local
```

---

## Adding Custom Commands

Define custom tasks in [`falcon.yaml`](../falcon.yaml):

```yaml
commands:
  my:task:
    confirm: false
    steps:
      - dfx canister call {{canister}} myMethod --query {{network}}

aliases:
  m:t: my:task
```

For scripts accepting arguments, use `script: ops/scripts/my-script.sh`.
Template available at [ops/templates/command.example.sh](../templates/command.example.sh).

