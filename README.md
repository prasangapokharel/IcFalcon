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
  <a href="https://github.com/prasangapokharel/IcFalcon/releases">Releases</a>
</p>

---

## Overview

IcFalcon is an open-source starter framework for building Internet Computer applications. You get a production-shaped Motoko canister, a Next.js frontend with shadcn/ui, and a global `falcon` CLI for scaffolding, building, and deploying.

| Layer | Technology |
|---|---|
| Backend | Motoko · `mo:core` · `api` → `service` → `repository` → `storage` |
| Frontend | Next.js · shadcn/ui · Internet Identity · static export |
| Tooling | `falcon` CLI · module scaffolds · [icp-hub](https://github.com/prasangapokharel/icp-hub) packages |

---

## Prerequisites

Install these before you begin:

- [dfx](https://internetcomputer.org/docs/current/developer-docs/getting-started/install) — local replica and deployment
- [mops](https://mops.one) — Motoko package manager
- **Node.js 20+** — frontend toolchain
- **bash** — required by the `falcon` CLI

---

## Installation

**Option A — npm (one command)**

```bash
npm create icfalcon@latest my-app
```

Installs the CLI, sets up backend + frontend, deploys locally, and starts the dev server. Open http://localhost:3000.

**Option B — git clone**

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon
./ops/install.sh
falcon s:init
```

This registers `falcon` on your PATH (`~/.local/bin`). Ensure that directory is in your shell `PATH`.

`falcon s:init` installs dependencies, deploys locally, and starts the dev server at http://localhost:3000.

---

### Manual clone steps

**1. Clone the repository**

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon
```

**2. Install the CLI**

```bash
./ops/install.sh
```

**3. Initialize the project**

```bash
falcon s:init
```

**4. Verify**

```bash
falcon b:test --local
falcon c:ping --local
falcon p:check --local
```

After `falcon s:init`, the dev server runs at http://localhost:3000.

---

## CLI reference

| Command | Description |
|---|---|
| `falcon s:init` | Project setup (toolchain + frontend) |
| `falcon m:f <Name>` | Scaffold a full module |
| `falcon add pkg <name>` | Install a hub package |
| `falcon b:test --local` | Build the canister |
| `falcon b:deploy --local` | Deploy to local replica |
| `falcon p:check --local` | Full backend + frontend build |
| `falcon p:list` | List available hub packages |

Use `--local` for the local replica. Omit it for mainnet; deploy will ask for confirmation.

Complete list: [ops/docs/commands.md](ops/docs/commands.md)

---

## Project structure

```
IcFalcon/
├── backend/       Motoko canister
├── frontend/      Next.js application
├── docs/          Architecture and guides
├── ops/           CLI and scaffolds
├── .agents/       Agent skills for contributors
└── falcon.yaml    CLI configuration
```

---

## Documentation

| Topic | Guide |
|---|---|
| First deploy | [Getting started](docs/gettingStarted/README.md) |
| Canister design | [Backend](docs/backend/README.md) |
| UI and auth | [Frontend](docs/frontend/README.md) |
| CLI and templates | [Ops](docs/ops/README.md) |
| Hub packages | [Packages](docs/packages/README.md) |

---

## Scaffold a module

```bash
falcon m:f Product
```

Generates backend layers, wires `main.mo`, and adds matching frontend service and panel files.

---

## Contributing

We welcome issues and pull requests.

1. Fork the repository and create a feature branch from `main`.
2. Follow existing patterns — see [AGENTS.md](AGENTS.md) and [docs/agents/README.md](docs/agents/README.md).
3. Run checks before opening a PR:

```bash
falcon b:test --local
falcon p:check --local
```

4. Open a pull request with a clear description of the change.

For hub packages, contribute to [icp-hub](https://github.com/prasangapokharel/icp-hub) separately.

---

## Security

- Mainnet deploy requires interactive confirmation in the terminal.
- Always upgrade production canisters with `--mode=upgrade`.
- Do not commit `.env`, `*.pem`, or `identity.json`.

---

## License

Source code in this repository is provided as-is for use and modification. Hub packages are licensed per their entries on [icp-hub](https://github.com/prasangapokharel/icp-hub).
