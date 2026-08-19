# IcFalcon

Internet Computer app framework: Motoko backend, Next.js frontend, `falcon` ops CLI.

## Quick start

```bash
./ops/install.sh
falcon s:init
falcon r:start
falcon b:deploy --local
falcon f:dev
```

## Scaffold a module

```bash
falcon m:f Order
falcon b:test --local
falcon b:deploy --local
```

## Packages (icp-hub)

```bash
falcon p:list
falcon add pkg wallet
falcon a:p dao
falcon p:ls
```

Hub: https://github.com/prasangapokharel/icp-hub

## Layout

| Path | Role |
|---|---|
| `backend/` | Motoko canister + `pkg/` |
| `frontend/` | Next.js + Internet Identity |
| `.agents/` | AI skills — start at [`.agents/SKILLS.md`](.agents/SKILLS.md) |
| `ops/` | CLI, templates, docs |
| `falcon.yaml` | Command config |
| `hub/` | Package registry (gitignored — separate repo) |

## Agent skills map

Read [`.agents/SKILLS.md`](.agents/SKILLS.md) first. Key skills:

| Task | Skill path |
|---|---|
| New feature | `.agents/skills/integrationStandard/SKILL.md` |
| Scaffold CLI | `falcon m:f <Name>` |
| Layer rules | `.agents/skills/layering/SKILL.md` |
| Code style | `.agents/skills/codingStandard/SKILL.md` |
| Errors | `.agents/skills/errorHandling/SKILL.md` |
| Migrations | `.agents/skills/migration/SKILL.md` |
| Tests | `.agents/skills/testingStandard/SKILL.md` |
| Endpoints | `.agents/skills/endpoints/SKILL.md` |
| Write Motoko | `.agents/skills/motoko/writingMotoko/SKILL.md` |
| Deploy | `.agents/skills/motoko/deployGuide/SKILL.md` |
| Ledger | `.agents/skills/motoko/ledgerIntegration/SKILL.md` |
| Frontend | `.agents/skills/frontendStandard/SKILL.md` |
| Logo / brand | `.agents/skills/logoStandard/SKILL.md` |
| II auth | `.agents/skills/motoko/internetIdentityAuth/SKILL.md` |

### Skill folders (camelCase)

```
.agents/skills/
├── codingStandard/
├── errorHandling/
├── integrationStandard/
├── layering/
├── migration/
├── testingStandard/
├── endpoints/
├── frontendStandard/
└── motoko/
    ├── writingMotoko/
    ├── testingMotoko/
    ├── migratingMotoko/
    ├── ledgerIntegration/
    ├── internetIdentityAuth/
    ├── cyclesAndCost/
    ├── buildAndTest/
    └── deployGuide/        # SKILL.md
```

## Docs

| File | Contents |
|---|---|
| [ops/README.md](ops/README.md) | Ops folder structure |
| [ops/docs/commands.md](ops/docs/commands.md) | Full `falcon` command reference |
| [ops/templates/feature/](ops/templates/feature/) | `falcon m:f` templates |

## Safety

- Upgrade only on mainnet
- Mainnet deploy requires TTY confirm
- Never commit `.env`, `*.pem`, `identity.json`
