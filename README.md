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
  <a href="docs/README.md">Docs</a> ·
  <a href="ops/docs/commands.md">Commands</a> ·
  <a href="https://github.com/prasangapokharel/icp-hub">Package hub</a>
</p>

---

## What you get

| Layer | Stack |
|---|---|
| Backend | Motoko · `mo:core` · layered canister (`api` → `service` → `repo` → `storage`) |
| Frontend | Next.js · shadcn/ui · Internet Identity · static export |
| Tooling | `falcon` CLI — scaffold, build, deploy, hub packages |

---

## Prerequisites

| Tool | Purpose |
|---|---|
| [dfx](https://internetcomputer.org/docs/current/developer-docs/getting-started/install) | Local replica & deploy |
| [mops](https://mops.one) | Motoko packages |
| Node.js 20+ | Frontend build |
| bash | `falcon` CLI |

---

## Quick start

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon

./ops/install.sh          # links falcon → ~/.local/bin
falcon s:init             # mops + moc + npm + shadcn + frontend build
falcon r:start --local    # start local replica
falcon b:deploy --local   # deploy app canister
```

Verify:

```bash
falcon b:test --local
falcon c:ping --local
falcon p:check --local
```

Open the built welcome UI from `frontend/out/` after deploy, or run `falcon f:dev` while developing.

---

## Common commands

| Command | What it does |
|---|---|
| `falcon s:init` | Full setup — backend toolchain + frontend + UI components |
| `falcon m:f Order` | Scaffold a module (backend + frontend) |
| `falcon add pkg wallet` | Install a package from [icp-hub](https://github.com/prasangapokharel/icp-hub) |
| `falcon b:test --local` | Build the canister |
| `falcon b:deploy --local` | Build + upgrade deploy |
| `falcon p:check --local` | Backend + frontend production build |
| `falcon p:list` | Browse hub packages |

Append `--local` for the local replica. Omit it for mainnet (deploy prompts for confirmation).

Full reference: [ops/docs/commands.md](ops/docs/commands.md)

---

## Project layout

```
IcFalcon/
├── backend/          Motoko canister (app)
├── frontend/         Next.js + shadcn UI
├── docs/             Guides (architecture · use case · how-to)
├── ops/              falcon CLI + templates
├── .agents/          AI agent skills
├── falcon.yaml       CLI config
└── AGENTS.md         Contributor map
```

---

## Documentation

| Guide | Description |
|---|---|
| [Getting started](docs/gettingStarted/README.md) | Install → init → deploy |
| [Backend](docs/backend/README.md) | Canister layers & modules |
| [Frontend](docs/frontend/README.md) | UI, services, II auth |
| [Ops / CLI](docs/ops/README.md) | `falcon` commands |
| [Packages](docs/packages/README.md) | icp-hub install |
| [Agents](docs/agents/README.md) | AI coding skills |

---

## Scaffold a feature

```bash
falcon m:f Product
```

Creates Motoko storage → repository → validator → service → API, wires `main.mo`, and adds frontend service + panel.

---

## Package hub

62 Motoko packages at **[github.com/prasangapokharel/icp-hub](https://github.com/prasangapokharel/icp-hub)**.

```bash
falcon p:list
falcon add pkg crud
falcon add pkg dao
falcon p:ls
```

---

## Safety

- Mainnet deploy requires an interactive terminal confirm
- Use `--mode=upgrade` for production upgrades
- Never commit `.env`, `*.pem`, or `identity.json`

---

## License

See repository license file. Hub packages follow their own licenses on icp-hub.
