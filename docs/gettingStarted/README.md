# Getting Started

## Architecture

```
./ops/install.sh     →  falcon CLI (~/.local/bin)
falcon s:init        →  backend mops + frontend npm/shadcn + static build
falcon r:start       →  local ICP replica
falcon b:deploy      →  canister on replica or mainnet
```

IcFalcon is a clone-and-own framework: one Motoko canister (`app`), static Next.js frontend, global `falcon` CLI.

## Use case

You need a production-shaped ICP app without boilerplate:

- Layered Motoko backend (api → service → repo → storage)
- Internet Identity on the frontend
- Hub packages (`falcon add pkg wallet`)
- Scaffold new modules (`falcon m:f Order`)

## Guide

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon
./ops/install.sh
falcon s:init
falcon r:start --local
falcon b:deploy --local
```

Verify:

```bash
falcon b:test --local
falcon c:ping --local
cd frontend && npm run build
```

Serve the welcome UI from `frontend/out/` after build, or use `falcon f:dev` while developing.

Next: [backend](../backend/README.md) · [frontend](../frontend/README.md)
