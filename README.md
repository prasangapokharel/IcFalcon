<p align="center">
  <img src="frontend/public/brand/logo.png" alt="IcFalcon" width="280" />
</p>

<h1 align="center">IcFalcon</h1>

<p align="center">
  <strong>The Motoko framework for Internet Computer apps.</strong><br />
  Clone it, own your canister, ship with one CLI.
</p>

<p align="center">
  <a href="docs/gettingStarted/README.md">Getting started</a> ·
  <a href="docs/README.md">Documentation</a> ·
  <a href="ops/docs/commands.md">CLI reference</a> ·
  <a href="AGENTS.md">Agent guide</a> ·
  <a href="https://github.com/prasangapokharel/icp-hub">icp-hub</a>
</p>

---

## Overview

IcFalcon is an open-source framework for Internet Computer applications: a production-shaped Motoko canister, a Next.js frontend with Internet Identity, and a global `falcon` CLI for scaffolding, testing, and deploying.

| Layer | Technology |
|---|---|
| Backend | Motoko · `mo:core` · `api` → `service` → `repository` → `storage` |
| Frontend | Next.js · shadcn/ui · Internet Identity · static export |
| Packages | [icp-hub](https://github.com/prasangapokharel/icp-hub) — 90+ Motoko packages via `falcon add pkg` |
| AI skills | `.agents/skills/` — task router at [`.agents/SKILLS.md`](.agents/SKILLS.md) |

---

## What's included

| Feature | Where |
|---|---|
| **Wallet reference demo** | `/wallet` — register, deposit address, balance, send (confirm flow), tx history |
| **Finance packages** | `wallet`, `transfer`, `transaction`, `subaccount`, `ledger`, `icrc1`, `icrc2`, `ckbtc` |
| **AI-safe transfers** | `proposeTransfer` → human confirm → `executeTransfer` (idempotency + rate limits) |
| **Unit tests** | `backend/testing/` — run via `falcon b:test --local` |
| **Module scaffold** | `falcon m:f <Name>` — full backend + frontend module |
| **Agent skills** | 49 `*Standard` skills for layering, finance, deploy, extensions |

---

## Prerequisites

- [dfx](https://internetcomputer.org/docs/current/developer-docs/getting-started/install) — local replica and deployment
- [mops](https://mops.one) — Motoko package manager
- **Node.js 20+**
- **bash** — required by the `falcon` CLI

---

## Installation

**Option A — npm (recommended)**

```bash
npm create icfalcon@latest my-app
```

Installs the CLI, sets up backend + frontend, deploys locally, and starts the dev server at http://localhost:3000.

**Option B — git clone**

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon
./ops/install.sh
falcon s:init
```

`./ops/install.sh` links `falcon` to `~/.local/bin`. Ensure that directory is on your `PATH`.

---

## Quick start

```bash
./ops/install.sh          # once — install falcon CLI
falcon s:init             # setup + local deploy + dev server
falcon b:test --local     # unit tests + canister build
falcon p:check --local    # skills validate + backend + frontend build
```

Open http://localhost:3000 — use **Wallet** on the home page or go to `/wallet`.

---

## CLI commands

Use `--local` for the local replica. Omit for mainnet (deploy commands ask for confirmation).

### Setup

| Command | Description |
|---|---|
| `falcon s:init` | Full project setup (mops, frontend, local deploy, dev server) |
| `falcon r:start --local` | Start local replica |
| `falcon r:stop --local` | Stop local replica |

### Backend

| Command | Description |
|---|---|
| `falcon b:test --local` | Run Motoko unit tests + build canister |
| `falcon b:build --local` | Build canister only |
| `falcon b:deploy --local` | Build + upgrade deploy |
| `falcon b:hash --local` | Module hash / canister info |
| `falcon b:logs --local` | Canister logs |

### Production check

| Command | Description |
|---|---|
| `falcon p:check --local` | Validate skills + build backend + frontend |
| `falcon p:ship --local` | Deploy backend + build frontend |
| `falcon sk:validate` | Validate `.agents/skills` structure and links |

### Scaffold & packages

| Command | Description |
|---|---|
| `falcon m:f <Name>` | Scaffold full module (backend + frontend) |
| `falcon p:list` | List hub packages |
| `falcon add pkg <name>` | Install package to `backend/pkg/` |
| `falcon p:ls` | List installed packages |
| `falcon p:push <name>` | Copy local pkg to `hub/` for publishing |

### Canister & frontend

| Command | Description |
|---|---|
| `falcon c:ping --local` | Health ping |
| `falcon c:call <method> [args] --local` | Call canister method |
| `falcon f:dev` | Next.js dev server |
| `falcon f:build` | Static export build |

Full reference: [ops/docs/commands.md](ops/docs/commands.md)

---

## Wallet demo

End-to-end custodial wallet reference (Phase 3):

1. Log in with Internet Identity at `/wallet`
2. **Register wallet** — get deposit address (ICRC + legacy hex)
3. Fund the deposit address on local ledger (minter identity)
4. **Send ICP** — Review calls `proposeTransfer`, Confirm calls `executeTransfer`
5. View transaction history

Install finance packages in a new project:

```bash
falcon add pkg wallet
falcon add pkg transfer
falcon add pkg transaction
```

Skills: [`.agents/SKILLS.md`](.agents/SKILLS.md) → Money core · AI-safe transfers (`aiActionsStandard`).

---

## Testing

```bash
falcon b:test --local
```

Runs `backend/testing/` (pkg + service tests with `MockLedger`) then `dfx build app`. Tests live in one folder:

```
backend/testing/
├── TestRunner.mo       # single entry — all tests
├── mocks/MockLedger.mo
├── pkg/                # pure logic tests
└── services/           # wallet + transfer invariant tests
```

Do not use `mops test` — tests are in `testing/`, not `test/`.

---

## Project structure

```
IcFalcon/
├── backend/
│   ├── src/            api, services, repositories, storage
│   ├── pkg/            hub packages (wallet, transfer, …)
│   ├── testing/        Motoko unit tests
│   └── scripts/        run-tests.sh
├── frontend/           Next.js + II + /wallet
├── ops/                falcon CLI, scaffolds, command docs
├── .agents/skills/     AI task skills (*Standard)
├── falcon.yaml         CLI config
├── AGENTS.md           contributor + agent map
└── hub/                separate repo (gitignored) — icp-hub clone
```

---

## Documentation

| Topic | Guide |
|---|---|
| First deploy | [docs/gettingStarted/README.md](docs/gettingStarted/README.md) |
| Canister design | [docs/backend/README.md](docs/backend/README.md) |
| UI and auth | [docs/frontend/README.md](docs/frontend/README.md) |
| CLI and templates | [docs/ops/README.md](docs/ops/README.md) |
| Hub packages | [docs/packages/README.md](docs/packages/README.md) |
| AI agents | [docs/agents/README.md](docs/agents/README.md) · [AGENTS.md](AGENTS.md) |
| Skill router | [.agents/SKILLS.md](.agents/SKILLS.md) |
| Command reference | [ops/docs/commands.md](ops/docs/commands.md) |

---

## Scaffold a module

```bash
falcon m:f Product
```

Creates storage, repository, validator, service, API mixin, types, frontend service, and panel. Wires `main.mo` automatically.

---

## Hub registry

Packages live in a separate repo: https://github.com/prasangapokharel/icp-hub

```bash
git clone https://github.com/prasangapokharel/icp-hub.git hub
falcon p:list
falcon add pkg wallet
```

Money packages (L2): `subaccount`, `ledger`, `icrc1`, `icrc2`, `wallet`, `transfer`, `transaction`, `ckbtc`.

---

## Contributing

1. Fork and branch from `main`.
2. Follow [AGENTS.md](AGENTS.md) and existing patterns.
3. Run before opening a PR:

```bash
falcon sk:validate
falcon b:test --local
falcon p:check --local
```

4. Hub package changes go to [icp-hub](https://github.com/prasangapokharel/icp-hub) separately.

---

## Security

- Mainnet deploy requires interactive terminal confirmation.
- Always upgrade production canisters with `--mode=upgrade`.
- Do not commit `.env`, `*.pem`, or `identity.json`.

---

## License

Source code in this repository is provided as-is for use and modification. Hub packages are licensed per their entries on [icp-hub](https://github.com/prasangapokharel/icp-hub).
