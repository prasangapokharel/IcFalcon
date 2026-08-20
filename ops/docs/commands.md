# Commands reference

Everything runs via global CLI: `falcon <command> [--local] [args]`

Mainnet by default. Local replica: append `--local`.

Install once: `./ops/install.sh`

---

## Packages (icp-hub)

Registry: https://github.com/prasangapokharel/icp-hub

```bash
falcon p:list
falcon add pkg slug
falcon a:p crud
falcon package:rbac
falcon p:ls
falcon p:push mypkg
```

Lock file: `backend/icp.pkg`

---

## Scaffold (Laravel-style)

```bash
falcon m:f Order          # full module: backend + frontend
falcon m:feature Product  # same
```

Creates storage, repository, validator, service, API, types, frontend service + panel. Wires `main.mo` automatically.

---

## Setup

| Short | Command | What |
|---|---|---|
| `s:init` | `setup:init` | mops + moc + frontend deps, shadcn, build, dev server |
| `r:start` | `replica:start` | `dfx start --background` |
| `r:stop` | `replica:stop` | `dfx stop` |

---

## Backend

| Short | Command | What |
|---|---|---|
| `b:test` | `backend:test` | Run Motoko unit tests + build canister |
| `b:build` | `backend:build` | Build canister |
| `b:deploy` | `backend:deploy` | Build + upgrade deploy |
| `b:hash` | `backend:hash` | Module hash / info |
| `b:logs` | `backend:logs` | Canister logs |

---

## Production

| Short | Command | What |
|---|---|---|
| `p:check` | `prod:check` | Validate skills + build backend + frontend |
| `p:ship` | `prod:ship` | Deploy backend + build frontend |

---

## Skills

| Short | Command | What |
|---|---|---|
| `sk:validate` | `skills:validate` | Validate `.agents/skills` — frontmatter, index, links |

```bash
falcon sk:validate
```

Runs `ops/scripts/validate-skills.sh` (also first step of `p:check`). Checks:

- Every skill folder name ends with `Standard` (camelCase)
- Every `SKILL.md` has `name:` + `description:` matching its folder
- No duplicate names; all skills indexed in `.agents/SKILLS.md`
- Strict sections for `financeStandard/*` and `logoStandard`
- Broken internal `skills/.../SKILL.md` links

---

## Canister

| Short | Command | What |
|---|---|---|
| `c:status` | `canister:status` | Status |
| `c:ping` | `canister:ping` | Health ping |
| `c:list` | `canister:list` | All canister IDs |
| `c:id` | `canister:id` | This canister ID |
| `c:info` | `canister:info` | Full info |
| `c:call` | `canister:call` | Call method |

```bash
falcon c:call status --local
falcon c:call createProduct '("test")' --update --local
```

---

## Cycles

| Short | Command | What |
|---|---|---|
| `y:bal` | `cycles:balance` | Balance + burn rate |
| `y:addr` | `cycles:address` | Ledger account ID |

---

## Users

| Short | Command | What |
|---|---|---|
| `u:count` | `users:count` | Status (user + feature counts) |

---

## Frontend

| Short | Command | What |
|---|---|---|
| `f:dev` | `frontend:dev` | Next.js dev |
| `f:build` | `frontend:build` | Static export |

---

## Adding commands

Edit [`falcon.yaml`](../falcon.yaml):

```yaml
commands:
  my:task:
    confirm: false
    steps:
      - dfx canister call {{canister}} myMethod --query {{network}}

aliases:
  x:task: my:task
```

For scripts with args, use `script:` instead of `steps:`.

Template: [ops/templates/command.example.sh](../templates/command.example.sh)
