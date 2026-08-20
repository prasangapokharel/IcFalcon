# Prerequisites

## Required tools

| Tool | Purpose |
|---|---|
| `dfx` | Replica, deploy, canister calls |
| `mops` | Motoko package manager |
| `moc` 1.6+ | Motoko compiler (via `falcon s:init`) |
| `node` / `npm` | Frontend build |
| `falcon` | Global CLI — `./ops/install.sh` |

## One-time setup

```bash
./ops/install.sh
falcon s:init
```

`falcon s:init` runs `mops install` and pins `moc` 1.6.0.

## Project layout

```
backend/
├── dfx.json          # canister: app
├── src/main.mo       # persistent actor + include mixins
├── pkg/              # mo:pkg/* shared packages
├── testing/          # *.test.mo (not test/)
└── scripts/          # run-tests.sh, etc.

frontend/
├── services/idl.ts   # sync from candid after API changes
└── services/client.ts
```

## Build rule

Always build from repo root via `falcon`:

```bash
falcon b:test --local     # dfx build app
falcon b:deploy --local   # build + upgrade deploy
```

Do not hand-edit `.dfx/` artifacts.
