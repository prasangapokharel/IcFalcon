# IcFalcon

Internet Computer app framework: Motoko backend, Next.js frontend, `falcon` ops CLI.

## Quick start

```bash
./ops/install.sh
falcon s:init
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

Read [`.agents/SKILLS.md`](.agents/SKILLS.md) first — layered router (Foundation → Money → Extensions → Apps).

**Naming:** every folder under `.agents/skills/` ends with `Standard` (categories and leaf skills), e.g. `financeStandard/walletStandard`. YAML `name:` must match the folder name.

**Validate after skill edits:**

```bash
falcon sk:validate          # skills structure + links
falcon audit code:motoko    # Motoko code style, layering & syntax (or: falcon a:c:m)
falcon p:check --local      # skills + code audit + backend + frontend build
```

### Core tasks

| Task | Skill path |
|---|---|
| New feature | `.agents/skills/integrationStandard/SKILL.md` |
| Scaffold CLI | `falcon m:f <Name>` |
| Code audit / linter | `falcon audit code:motoko` / `falcon a:c:m` |
| Layer rules | `.agents/skills/layeringStandard/SKILL.md` |
| Multi-canister mesh | `.agents/skills/falconUniverseStandard/SKILL.md` |
| Code style | `.agents/skills/codingStandard/SKILL.md` |
| Errors | `.agents/skills/errorHandlingStandard/SKILL.md` |
| Migrations | `.agents/skills/migrationStandard/SKILL.md` |
| Tests | `.agents/skills/testingStandard/SKILL.md` |
| Endpoints | `.agents/skills/endpointsStandard/SKILL.md` |
| Write Motoko | `.agents/skills/motokoStandard/writingMotokoStandard/SKILL.md` |
| Project setup | `.agents/skills/guideStandard/projectSetupStandard/SKILL.md` |
| Local deploy | `.agents/skills/guideStandard/localDeployStandard/SKILL.md` |
| Production deploy | `.agents/skills/guideStandard/productionDeployStandard/SKILL.md` |
| ICPay controllers | `.agents/skills/icpayControllerStandard/SKILL.md` |
| Release | `.agents/skills/guideStandard/releaseStandard/SKILL.md` |
| Deploy reference | `.agents/skills/motokoStandard/deployGuideStandard/SKILL.md` |
| Frontend | `.agents/skills/frontendStandard/SKILL.md` |
| @icp-sdk | `.agents/skills/icpsdkStandard/SKILL.md` |
| **Wallet demo (Phase 3)** | `/wallet` — [`docs/phase/3/PLAN.md`](docs/phase/3/PLAN.md) |
| Logo / brand | `.agents/skills/logoStandard/SKILL.md` |
| II auth | `.agents/skills/motokoStandard/internetIdentityAuthStandard/SKILL.md` |
| RBAC / auth | `.agents/skills/motokoStandard/authorizationStandard/SKILL.md` |
| HTTP outcalls | `.agents/skills/motokoStandard/httpOutcallsStandard/SKILL.md` |
| Extensions (OpenAI, Stripe, email, …) | [`.agents/SKILLS.md`](.agents/SKILLS.md) → Extensions |
| Connectors (Slack, Gmail, Calendar) | [`.agents/SKILLS.md`](.agents/SKILLS.md) → Connectors |

### Finance standards (`financeStandard/`)

Hub money layer for Phase 1. **Hazards only** (fees, double-credit, address formats): [`motokoStandard/ledgerIntegrationStandard`](.agents/skills/motokoStandard/ledgerIntegrationStandard/SKILL.md). **Composition patterns** below.

| What | When to use | Skill | Hub packages |
|---|---|---|---|
| **Wallet** — derive accounts, deposit addresses, balance reads | New wallet feature, deposit UI, multi-token (ICP / ckBTC) | [`walletStandard`](.agents/skills/financeStandard/walletStandard/SKILL.md) | `subaccount`, `ledger`, `icrc1`, `wallet` |
| **Transfer** — send ICRC, fee reserve, idempotency | `TransferService.send`, user-to-user sends | [`transferStandard`](.agents/skills/financeStandard/transferStandard/SKILL.md) | `transfer`, `transaction`, `icrc1` |
| **Transaction** — history index, deposit sync | `TxStore`, history API, reconciliation | [`transactionStandard`](.agents/skills/financeStandard/transactionStandard/SKILL.md) | `transaction` |

**Architecture rules (all finance skills):**

- Hub pkgs = pure logic; only `services/` awaits the ledger
- `amount + fee <= balance` before transfer
- Two tx rows per internal transfer
- `subaccount.fromPrincipal` only — never hand-roll
- Layering: `api → services → repositories → storage`

```bash
falcon add pkg wallet      # pulls subaccount, ledger, icrc1, wallet
falcon add pkg transfer
falcon add pkg transaction
```

Reference implementation (Phase 3): [docs/phase/3/PLAN.md](docs/phase/3/PLAN.md)

### Skill folders (camelCase, `*Standard` suffix)

```
.agents/skills/
├── codingStandard/
├── errorHandlingStandard/
├── integrationStandard/
├── layeringStandard/
├── migrationStandard/
├── testingStandard/
├── endpointsStandard/
├── frontendStandard/
├── logoStandard/
├── icpayControllerStandard/
├── icpsdkStandard/
├── falconUniverseStandard/
├── extensionsStandard/
│   ├── openAiStandard/
│   ├── objectStorageStandard/
│   ├── stripeStandard/
│   ├── emailStandard/
│   └── …
├── connectorsStandard/
│   ├── slackConnectorStandard/
│   ├── googleMailConnectorStandard/
│   └── googleCalendarConnectorStandard/
├── financeStandard/
│   ├── walletStandard/
│   ├── transferStandard/
│   └── transactionStandard/
├── guideStandard/
│   ├── projectSetupStandard/
│   ├── localDeployStandard/
│   ├── productionDeployStandard/
│   └── releaseStandard/
└── motokoStandard/
    ├── writingMotokoStandard/
    ├── testingMotokoStandard/
    ├── migratingMotokoStandard/
    ├── migrationTroubleshootingStandard/
    ├── httpOutcallsStandard/
    ├── authorizationStandard/
    ├── ledgerIntegrationStandard/
    ├── internetIdentityAuthStandard/
    ├── cyclesAndCostStandard/
    ├── buildAndTestStandard/
    └── deployGuideStandard/
```

## Docs

Read [`ops/docs/`](ops/docs/README.md) for full project and architecture documentation.

| Document | Contents |
|---|---|
| [ops/docs/README.md](ops/docs/README.md) | Documentation index & framework overview |
| [ops/docs/commands.md](ops/docs/commands.md) | Full `falcon` CLI reference & aliases |
| [ops/docs/architecture.md](ops/docs/architecture.md) | 4-tier Motoko architecture & persistent memory |
| [ops/docs/universe.md](ops/docs/universe.md) | Falcon Universe multi-canister event mesh ("Kafka for Motoko") |
| [ops/docs/audit.md](ops/docs/audit.md) | Motoko code validator & linter (`falcon audit code:motoko`) |
| [ops/docs/packages.md](ops/docs/packages.md) | `icp-hub` packages (`falcon add pkg`), registry list |
| [ops/docs/finance.md](ops/docs/finance.md) | Money layer: ICPay, subaccounts, ICRC-1/2, custodial wallets |
| [ops/docs/frontend.md](ops/docs/frontend.md) | Next.js frontend with `@icp-sdk/core` & `@icp-sdk/auth` |
| [ops/README.md](ops/README.md) | Ops folder structure & tooling |
| [ops/templates/feature/](ops/templates/feature/) | `falcon m:f` scaffold templates |

## Safety

- Upgrade only on mainnet
- Mainnet deploy requires TTY confirm
- Never commit `.env`, `*.pem`, `identity.json`
