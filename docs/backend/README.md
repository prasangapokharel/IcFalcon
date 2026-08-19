# Backend

## Architecture

```
backend/
├── src/
│   ├── main.mo              persistent actor + include mixins
│   ├── api/v1/              thin HTTP-facing mixins
│   ├── services/            business logic (transient)
│   ├── repositories/        CRUD
│   ├── storage/             stable maps
│   ├── validators/
│   └── types.mo
├── pkg/                     shared mo:pkg/* (local + hub)
├── testing/                 *.test.mo
├── dfx.json                 canister: app
└── mops.toml
```

Layer rule: api → service → repository → storage. No shortcuts.

## Use case

Build canister features that survive upgrades:

- Auth and user records
- Domain modules (orders, products, wallets)
- ICRC / ledger integration via hub packages

## Guide

```bash
falcon m:f Order          # scaffold all layers + wire main.mo
falcon b:test --local     # dfx build app
falcon b:deploy --local   # upgrade deploy
falcon b:hash --local     # module hash before mainnet
```

After API changes, sync `frontend/services/idl.ts`.

Skills: `.agents/skills/layering/SKILL.md`, `.agents/skills/integrationStandard/SKILL.md`
