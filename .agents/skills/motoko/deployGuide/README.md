# IcFalcon Deploy Guide

Build, install, verify, and upgrade the `app` Motoko canister with **`falcon`**.

Entry skill: [`SKILL.md`](./SKILL.md)

## Read in order

| # | Document | When to read |
|---|---|---|
| 1 | [prerequisites.md](./prerequisites.md) | Tools, identities, mops |
| 2 | [build.md](./build.md) | Build, tests, candid |
| 3 | [local-deploy.md](./local-deploy.md) | Local replica + frontend |
| 4 | [mainnet-fresh.md](./mainnet-fresh.md) | First install on IC |
| 5 | [mainnet-upgrade.md](./mainnet-upgrade.md) | Upgrade existing canister |
| 6 | [frontend-connection.md](./frontend-connection.md) | Env vars, agent, IDL sync |
| 7 | [scripts-reference.md](./scripts-reference.md) | `backend/scripts/` |
| 8 | [troubleshooting.md](./troubleshooting.md) | Errors and fixes |
| 9 | [release-checklist.md](./release-checklist.md) | Pre-ship checklist |

## Quick commands

```bash
falcon s:init
falcon r:start --local
falcon b:test --local
falcon b:deploy --local
falcon c:ping --local
falcon f:dev
```

Mainnet: `falcon b:test` → `falcon p:check` → `falcon b:deploy` → `falcon p:ship`

## Related

- [`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md) — feature ship checklist
- [`../../migration/SKILL.md`](../../migration/SKILL.md) — upgrade migrations
- [`../../../../ops/docs/commands.md`](../../../../ops/docs/commands.md) — full `falcon` reference
