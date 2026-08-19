# IcFalcon Agent Skills

Task router for AI agents working in this repo. Read the skill that matches your task.

## Project map

| Path | Role |
|---|---|
| `backend/src/` | Motoko canister (api → services → repos → storage) |
| `backend/pkg/` | Shared Motoko packages (`mo:pkg/...`) |
| `frontend/` | Next.js + Internet Identity |
| `ops/` | `falcon` CLI, templates, docs |
| `falcon.yaml` | Command config |
| `.agents/skills/` | This folder |

## Task → skill

| Task | Skill |
|---|---|
| Add new feature / module | [`integrationStandard/SKILL.md`](skills/integrationStandard/SKILL.md) |
| Scaffold with CLI | `falcon m:f <Name>` + [`integrationStandard/SKILL.md`](skills/integrationStandard/SKILL.md) |
| Single endpoint | [`endpoints/SKILL.md`](skills/endpoints/SKILL.md) |
| Layer architecture | [`layering/SKILL.md`](skills/layering/SKILL.md) |
| Code style / naming | [`codingStandard/SKILL.md`](skills/codingStandard/SKILL.md) |
| Errors / ApiResult | [`errorHandling/SKILL.md`](skills/errorHandling/SKILL.md) |
| Upgrade / migration | [`migration/SKILL.md`](skills/migration/SKILL.md) |
| Run tests | [`testingStandard/SKILL.md`](skills/testingStandard/SKILL.md) |
| Write Motoko | [`motoko/writingMotoko/SKILL.md`](skills/motoko/writingMotoko/SKILL.md) |
| Deploy | [`motoko/deployGuide/SKILL.md`](skills/motoko/deployGuide/SKILL.md) + `falcon b:deploy` |
| Ledger / ICRC | [`motoko/ledgerIntegration/SKILL.md`](skills/motoko/ledgerIntegration/SKILL.md) |
| Frontend | [`frontendStandard/SKILL.md`](skills/frontendStandard/SKILL.md) |
| Logo / brand | [`logoStandard/SKILL.md`](skills/logoStandard/SKILL.md) |
| II auth | [`motoko/internetIdentityAuth/SKILL.md`](skills/motoko/internetIdentityAuth/SKILL.md) |
| Install pkg | `falcon add pkg <name>` — hub: github.com/prasangapokharel/icp-hub |
| Add falcon command | [`ops/docs/commands.md`](../ops/docs/commands.md) |

## IcFalcon skills (camelCase folders)

```
.agents/skills/
├── codingStandard/       # naming, imports, file size
├── errorHandling/        # ApiResult, validators
├── integrationStandard/  # full feature checklist
├── layering/             # api → service → repo → storage
├── migration/            # stable memory upgrades
├── testingStandard/      # run-tests, test layout
├── endpoints/            # api/v1 mixin pattern
├── frontendStandard/     # Next.js, shadcn, services/hooks/lib
├── logoStandard/         # brand lockup, colors, typography
└── motoko/               # Motoko language + ICP reference
    ├── writingMotoko/
    ├── testingMotoko/
    ├── migratingMotoko/
    ├── migratingMotokoEnhanced/
    ├── ledgerIntegration/
    ├── internetIdentityAuth/
    ├── cyclesAndCost/
    ├── buildAndTest/       # compiler repo only
    └── deployGuide/        # SKILL.md + deploy docs
```

## CLI quick reference

```bash
falcon m:f Order           # scaffold module
falcon add pkg wallet      # install hub package
falcon b:test --local        # build canister
falcon b:deploy --local    # deploy
falcon p:check --local     # full check
falcon f:dev               # frontend
```

Full commands: [`ops/docs/commands.md`](../ops/docs/commands.md)

## Rules

- Use `mo:core` not `mo:base`
- Use `persistent actor` + `include` mixins in `main.mo`
- Storage maps are NOT `transient`; services ARE `transient`
- Max ~300 lines per file
- Never commit `.env`, `*.pem`, `identity.json`
