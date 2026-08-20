---
name: productionDeployStandard
description: >-
  Mainnet production deploy for IcFalcon — fresh install, upgrade, verify, ship frontend.
  TTY confirm required. Read before any `falcon b:deploy` without `--local`.
---

# Production Deploy Standard

Ship the `app` canister to the Internet Computer. Use the global `falcon` CLI.

## When to use

| Situation | Path |
|---|---|
| First mainnet install | [Fresh install](#fresh-install) |
| Upgrade existing canister | [Upgrade](#upgrade) |
| Ship static frontend | [Ship frontend](#ship-frontend) |

Detail docs: [`motokoStandard/deployGuideStandard/`](../../motokoStandard/deployGuideStandard/)

---

## Pre-deploy checklist

- [ ] `falcon b:test` — backend build green
- [ ] `falcon p:check` — backend + frontend green
- [ ] Stable shape changes wired — [`migration/SKILL.md`](../../migrationStandard/SKILL.md)
- [ ] Migration tested: write → upgrade → read (if schema changed)
- [ ] `frontend/services/idl.ts` synced if API changed
- [ ] Identity has controller access and enough cycles
- [ ] `falcon b:hash` recorded before upgrade (not fresh install)

---

## Fresh install

```bash
falcon b:test
falcon p:check
falcon b:deploy
```

TTY confirmation is required on mainnet.

Record canister id:

```bash
falcon c:id
```

Production env (`frontend/.env` or host config):

- `NEXT_PUBLIC_CANISTER_ID_APP` — from `falcon c:id`
- `NEXT_PUBLIC_DFX_NETWORK=ic`
- `NEXT_PUBLIC_HOST=https://icp-api.io`

Verify:

```bash
falcon c:ping
falcon c:status
falcon c:info
```

Detail: [`motokoStandard/deployGuideStandard/mainnet-fresh.md`](../../motokoStandard/deployGuideStandard/mainnet-fresh.md)

---

## Upgrade

Only upgrade on mainnet when state must be preserved.

```bash
falcon b:test
falcon b:hash
falcon p:check
falcon b:deploy
```

Post-upgrade:

```bash
falcon c:ping
falcon c:status
```

Run domain queries — persisted data must survive.

Detail: [`motokoStandard/deployGuideStandard/mainnet-upgrade.md`](../../motokoStandard/deployGuideStandard/mainnet-upgrade.md)

---

## Ship frontend

```bash
falcon p:ship
```

Or build only: `falcon f:build`

Env wiring: [`motokoStandard/deployGuideStandard/frontend-connection.md`](../../motokoStandard/deployGuideStandard/frontend-connection.md)

---

## Flow

```
falcon b:test → falcon b:hash → falcon p:check → falcon b:deploy → falcon c:ping → smoke tests → falcon p:ship
```

---

## Never

- Deploy untested migrations to mainnet
- Skip `falcon b:hash` before upgrade
- Mark storage maps `transient` inside `persistent actor`
- Commit `.env`, `*.pem`, `identity.json`
- Force deploy without TTY when `falcon` requires confirmation

---

## Related

| Topic | Path |
|---|---|
| Local deploy | [`localDeployStandard/SKILL.md`](../localDeployStandard/SKILL.md) |
| Project setup | [`projectSetupStandard/SKILL.md`](../projectSetupStandard/SKILL.md) |
| Release checklist | [`releaseStandard/SKILL.md`](../releaseStandard/SKILL.md) |
| Deploy reference | [`motokoStandard/deployGuideStandard/SKILL.md`](../../motokoStandard/deployGuideStandard/SKILL.md) |
| Migrations | [`migration/SKILL.md`](../../migrationStandard/SKILL.md) |
| Commands | [`ops/docs/commands.md`](../../../../ops/docs/commands.md) |
