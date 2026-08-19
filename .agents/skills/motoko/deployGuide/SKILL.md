---
name: IcFalcon-deployGuide
description: >-
  Build, deploy, upgrade, and verify IcFalcon canisters with the global falcon CLI.
  Read before local deploy, mainnet ship, or troubleshooting dfx/moc issues.
---

# IcFalcon — Deploy Guide

Use the global `falcon` CLI (`ops/falcon` + `falcon.yaml`). Canister name: **`app`**.

## Workflow skills (start here)

| Task | Skill |
|---|---|
| First-time setup | [`../../guide/projectSetupStandard/SKILL.md`](../../guide/projectSetupStandard/SKILL.md) |
| Local deploy | [`../../guide/localDeployStandard/SKILL.md`](../../guide/localDeployStandard/SKILL.md) |
| Production deploy | [`../../guide/productionDeployStandard/SKILL.md`](../../guide/productionDeployStandard/SKILL.md) |
| Release checklist | [`../../guide/releaseStandard/SKILL.md`](../../guide/releaseStandard/SKILL.md) |

## Quick start (local)

```bash
./ops/install.sh
falcon s:init
falcon r:start --local
falcon b:test --local
falcon b:deploy --local
falcon c:ping --local
falcon f:dev
```

## Read in order

| # | Doc | When |
|---|---|---|
| 1 | [prerequisites.md](./prerequisites.md) | Tools, identity, mops |
| 2 | [build.md](./build.md) | Build, tests, candid |
| 3 | [local-deploy.md](./local-deploy.md) | Local replica + frontend |
| 4 | [mainnet-fresh.md](./mainnet-fresh.md) | First mainnet install |
| 5 | [mainnet-upgrade.md](./mainnet-upgrade.md) | Upgrade existing canister |
| 6 | [frontend-connection.md](./frontend-connection.md) | Env vars, IDL sync |
| 7 | [scripts-reference.md](./scripts-reference.md) | Backend scripts |
| 8 | [troubleshooting.md](./troubleshooting.md) | Common errors |
| 9 | [release-checklist.md](./release-checklist.md) | Pre-ship checklist |

## Mainnet

```bash
falcon b:test              # build backend
falcon p:check             # backend + frontend
falcon b:hash              # record module hash before upgrade
falcon b:deploy            # TTY confirm required
falcon p:ship              # deploy + frontend build
```

Full command list: [`ops/docs/commands.md`](../../../../ops/docs/commands.md)

## Related skills

| Skill | Path |
|---|---|
| Integration | [`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md) |
| Migrations | [`../../migration/SKILL.md`](../../migration/SKILL.md) |
| Testing | [`../../testingStandard/SKILL.md`](../../testingStandard/SKILL.md) |
