# IcFalcon Agent Skills

Task router for AI agents. **Read one skill per task** — do not load the whole tree.

## How to pick a skill

1. Match your task in the tables below
2. Read that `SKILL.md` only
3. Follow **Related** links if needed

**Dependency direction:**

```
Foundation → Money Core → Extensions / Connectors → Applications
```

---

## Skill standard

Every skill under `.agents/skills/<category>/<skillName>/SKILL.md` must have:

| Section | Required |
|---|---|
| Folder name | camelCase, ends with `Standard` (leaf skills and category folders, e.g. `financeStandard/walletStandard`) |
| YAML `name` | Matches folder name (camelCase, ends with `Standard`) |
| YAML `description` | When an agent should load this skill |
| Purpose | One paragraph |
| When to use | Bullet triggers |
| Pattern / packages | How to implement in IcFalcon |
| Rules | Architecture and security constraints |
| Related | Links to adjacent skills (not duplicate docs) |

**Do not:** one skill per function, per package, or per API method.  
**Do not:** duplicate ledger hazard docs — use `motokoStandard/ledgerIntegrationStandard` + `financeStandard/*`.

**Validate before merge:**

```bash
falcon sk:validate    # or: bash ops/scripts/validate-skills.sh
```

Also runs as the first step of `falcon p:check`.

---

## Foundation

| Task | Skill |
|---|---|
| Layer rules | [`layering/SKILL.md`](skills/layeringStandard/SKILL.md) |
| Code style | [`codingStandard/SKILL.md`](skills/codingStandard/SKILL.md) |
| Errors / ApiResult | [`errorHandling/SKILL.md`](skills/errorHandlingStandard/SKILL.md) |
| Stable memory migrations | [`migration/SKILL.md`](skills/migrationStandard/SKILL.md) |
| Run tests | [`testingStandard/SKILL.md`](skills/testingStandard/SKILL.md) |
| Write Motoko | [`motokoStandard/writingMotokoStandard/SKILL.md`](skills/motokoStandard/writingMotokoStandard/SKILL.md) |
| API endpoints | [`endpoints/SKILL.md`](skills/endpointsStandard/SKILL.md) |

---

## Money core

| Task | Skill |
|---|---|
| Wallet, deposit, balance | [`financeStandard/walletStandard/SKILL.md`](skills/financeStandard/walletStandard/SKILL.md) |
| Send ICP / ICRC | [`financeStandard/transferStandard/SKILL.md`](skills/financeStandard/transferStandard/SKILL.md) |
| Tx history, deposit sync | [`financeStandard/transactionStandard/SKILL.md`](skills/financeStandard/transactionStandard/SKILL.md) |
| AI-safe transfers (propose/execute) | [`extensionsStandard/aiActionsStandard/SKILL.md`](skills/extensionsStandard/aiActionsStandard/SKILL.md) |
| Ledger hazards (fees, double-credit) | [`motokoStandard/ledgerIntegrationStandard/SKILL.md`](skills/motokoStandard/ledgerIntegrationStandard/SKILL.md) |

Hub packages: `subaccount`, `ledger`, `icrc1`, `icrc2`, `wallet`, `transfer`, `transaction`, `ckbtc` — install via `falcon add pkg <name>`.

---

## Applications

| Task | Skill |
|---|---|
| New feature (full checklist) | [`integrationStandard/SKILL.md`](skills/integrationStandard/SKILL.md) |
| Scaffold module | `falcon m:f <Name>` + integrationStandard |
| Frontend | [`frontendStandard/SKILL.md`](skills/frontendStandard/SKILL.md) |
| Logo / favicon | [`logoStandard/SKILL.md`](skills/logoStandard/SKILL.md) |

Frontend detail skills: [`frontend/.agents/SKILLS.md`](../frontend/.agents/SKILLS.md).

---

## Auth & ICP protocol

| Task | Skill |
|---|---|
| Internet Identity | [`motokoStandard/internetIdentityAuthStandard/SKILL.md`](skills/motokoStandard/internetIdentityAuthStandard/SKILL.md) |
| RBAC / caller guards | [`motokoStandard/authorizationStandard/SKILL.md`](skills/motokoStandard/authorizationStandard/SKILL.md) |
| HTTP outcalls | [`motokoStandard/httpOutcallsStandard/SKILL.md`](skills/motokoStandard/httpOutcallsStandard/SKILL.md) |
| Cycles / cost | [`motokoStandard/cyclesAndCostStandard/SKILL.md`](skills/motokoStandard/cyclesAndCostStandard/SKILL.md) |
| Canister tests (detail) | [`motokoStandard/testingMotokoStandard/SKILL.md`](skills/motokoStandard/testingMotokoStandard/SKILL.md) |
| Inline migration | [`motokoStandard/migratingMotokoStandard/SKILL.md`](skills/motokoStandard/migratingMotokoStandard/SKILL.md) |
| Multi-step migration | [`motokoStandard/migratingMotokoEnhancedStandard/SKILL.md`](skills/motokoStandard/migratingMotokoEnhancedStandard/SKILL.md) |
| Migration debug | [`motokoStandard/migrationTroubleshootingStandard/SKILL.md`](skills/motokoStandard/migrationTroubleshootingStandard/SKILL.md) |

---

## Extensions

| Task | Skill |
|---|---|
| OpenAI / LLM | [`extensionsStandard/openAiStandard/SKILL.md`](skills/extensionsStandard/openAiStandard/SKILL.md) |
| AI-safe money actions | [`extensionsStandard/aiActionsStandard/SKILL.md`](skills/extensionsStandard/aiActionsStandard/SKILL.md) |
| Object storage | [`extensionsStandard/objectStorageStandard/SKILL.md`](skills/extensionsStandard/objectStorageStandard/SKILL.md) |
| Stripe | [`extensionsStandard/stripeStandard/SKILL.md`](skills/extensionsStandard/stripeStandard/SKILL.md) |
| Email (transactional) | [`extensionsStandard/emailStandard/SKILL.md`](skills/extensionsStandard/emailStandard/SKILL.md) |
| Email (raw multi-recipient) | [`extensionsStandard/emailRawStandard/SKILL.md`](skills/extensionsStandard/emailRawStandard/SKILL.md) |
| Email verification | [`extensionsStandard/emailVerificationStandard/SKILL.md`](skills/extensionsStandard/emailVerificationStandard/SKILL.md) |
| Email marketing | [`extensionsStandard/emailMarketingStandard/SKILL.md`](skills/extensionsStandard/emailMarketingStandard/SKILL.md) |
| Calendar invites (.ics) | [`extensionsStandard/emailCalendarEventsStandard/SKILL.md`](skills/extensionsStandard/emailCalendarEventsStandard/SKILL.md) |
| Invite / RSVP | [`extensionsStandard/inviteLinksStandard/SKILL.md`](skills/extensionsStandard/inviteLinksStandard/SKILL.md) |
| User approval | [`extensionsStandard/userApprovalStandard/SKILL.md`](skills/extensionsStandard/userApprovalStandard/SKILL.md) |
| OQL setup | [`extensionsStandard/oqlStandard/SKILL.md`](skills/extensionsStandard/oqlStandard/SKILL.md) |
| OQL queries | [`extensionsStandard/queryingOqlStandard/SKILL.md`](skills/extensionsStandard/queryingOqlStandard/SKILL.md) |
| Post to X | [`extensionsStandard/postingToXStandard/SKILL.md`](skills/extensionsStandard/postingToXStandard/SKILL.md) |
| Camera | [`extensionsStandard/cameraStandard/SKILL.md`](skills/extensionsStandard/cameraStandard/SKILL.md) |
| QR scanner | [`extensionsStandard/qrCodeStandard/SKILL.md`](skills/extensionsStandard/qrCodeStandard/SKILL.md) |

---

## Connectors

| Task | Skill |
|---|---|
| Slack | [`connectorsStandard/slackConnectorStandard/SKILL.md`](skills/connectorsStandard/slackConnectorStandard/SKILL.md) |
| Gmail | [`connectorsStandard/googleMailConnectorStandard/SKILL.md`](skills/connectorsStandard/googleMailConnectorStandard/SKILL.md) |
| Google Calendar | [`connectorsStandard/googleCalendarConnectorStandard/SKILL.md`](skills/connectorsStandard/googleCalendarConnectorStandard/SKILL.md) |

---

## Deploy & ops

| Task | Skill |
|---|---|
| Project setup | [`guideStandard/projectSetupStandard/SKILL.md`](skills/guideStandard/projectSetupStandard/SKILL.md) |
| Local deploy | [`guideStandard/localDeployStandard/SKILL.md`](skills/guideStandard/localDeployStandard/SKILL.md) |
| Production deploy | [`guideStandard/productionDeployStandard/SKILL.md`](skills/guideStandard/productionDeployStandard/SKILL.md) |
| Release | [`guideStandard/releaseStandard/SKILL.md`](skills/guideStandard/releaseStandard/SKILL.md) |
| Deploy reference | [`motokoStandard/deployGuideStandard/SKILL.md`](skills/motokoStandard/deployGuideStandard/SKILL.md) |
| Falcon CLI | [`ops/docs/commands.md`](../ops/docs/commands.md) |

---

## Motoko compiler repo only

**Not for IcFalcon app work** — only when hacking the Motoko compiler itself:

| Task | Skill |
|---|---|
| Build moc / run test-runner | [`motokoStandard/buildAndTestStandard/SKILL.md`](skills/motokoStandard/buildAndTestStandard/SKILL.md) |
| Bump pocket-ic | [`motokoStandard/bumpPocketIcStandard/SKILL.md`](skills/motokoStandard/bumpPocketIcStandard/SKILL.md) |
| Bump Rust nightly | [`motokoStandard/bumpRustNightlyStandard/SKILL.md`](skills/motokoStandard/bumpRustNightlyStandard/SKILL.md) |

---

## Complete index (48 skills)

```
.agents/skills/
├── codingStandard/          errorHandlingStandard/   layeringStandard/
├── migrationStandard/       testingStandard/         integrationStandard/
├── endpointsStandard/     frontendStandard/        logoStandard/
├── financeStandard/
│   ├── walletStandard/      transferStandard/        transactionStandard/
├── guideStandard/
│   ├── projectSetupStandard/   localDeployStandard/
│   ├── productionDeployStandard/   releaseStandard/
├── extensionsStandard/      (15 *Standard skills — see table above)
├── connectorsStandard/      (3 *ConnectorStandard skills)
└── motokoStandard/
    ├── writingMotokoStandard/   ledgerIntegrationStandard/   authorizationStandard/
    ├── httpOutcallsStandard/    internetIdentityAuthStandard/ cyclesAndCostStandard/
    ├── testingMotokoStandard/   migratingMotokoStandard/      migratingMotokoEnhancedStandard/
    ├── migrationTroubleshootingStandard/   deployGuideStandard/
    └── buildAndTestStandard/    bumpPocketIcStandard/         bumpRustNightlyStandard/  ← compiler only
```

---

## CLI

```bash
falcon m:f Order           # scaffold module
falcon add pkg wallet      # hub package
falcon sk:validate         # skills CI
falcon b:test --local      # build canister
```

## Global rules

- `mo:core` not `mo:base`
- `persistent actor` + mixins in `main.mo`
- Storage NOT `transient`; services ARE `transient`
- Max ~300 lines per file
- Never commit `.env`, `*.pem`, `identity.json`
