# IcFalcon — Internet Computer App Framework

Motoko backend + Next.js frontend + `falcon` CLI. Clone, customize, deploy.

## Quick start

```bash
./ops/install.sh          # global falcon command
falcon s:init                # mops + moc toolchain
falcon r:start               # local replica
falcon b:deploy --local      # deploy canister
falcon f:dev                 # frontend dev server
```

## Root layout

```
IcFalcon/
├── backend/              # Motoko canister (api → services → repos → storage)
├── frontend/             # Next.js + Internet Identity
├── .agents/              # AI coding skills
├── ops/                  # CLI, templates, docs
├── falcon.yaml              # command config
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
