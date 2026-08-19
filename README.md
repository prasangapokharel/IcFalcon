# IcFalcon — Internet Computer App Framework

**Build fast. Deploy on chain.**

Motoko backend + Next.js frontend + `falcon` CLI.

Docs: [docs/README.md](docs/README.md)

## Quick start

```bash
./ops/install.sh
falcon s:init
falcon r:start --local
falcon b:deploy --local
```

## Root layout

```
IcFalcon/
├── backend/
├── frontend/
├── docs/                 # architecture + guides per area
├── .agents/
├── ops/
├── falcon.yaml
├── AGENTS.md
└── README.md
```

## Common commands

| Short | What |
|---|---|
| `falcon m:f Order` | Scaffold full module |
| `falcon add pkg wallet` | Install hub package |
| `falcon b:test --local` | Build canister |
| `falcon p:ship --local` | Deploy + build frontend |
| `falcon p:list` | Browse package hub |

Full reference: [ops/docs/commands.md](ops/docs/commands.md)

## Package hub

https://github.com/prasangapokharel/icp-hub — 62 Motoko packages.

```bash
falcon add pkg crud
falcon add pkg dao
```

## Safety

- Upgrade only on mainnet (`--mode=upgrade`)
- Mainnet deploy requires TTY confirm
- Never commit `.env`, `*.pem`, `identity.json`
