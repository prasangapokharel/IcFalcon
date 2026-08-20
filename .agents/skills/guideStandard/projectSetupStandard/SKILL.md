---
name: projectSetupStandard
description: >-
  First-time IcFalcon project setup — install CLI, init frontend, start replica, first local deploy.
---

# Project Setup Standard

Bootstrap a fresh clone for local development.

## Install

```bash
./ops/install.sh
```

Installs the global `falcon` CLI from `ops/falcon` using `falcon.yaml`.

---

## Init project

```bash
falcon s:init
```

Runs:

- `ops/scripts/setup-init.sh` — backend deps (mops), frontend setup, then `npm run dev`
- `ops/scripts/setup-frontend.sh` — `npm install`, shadcn `--all`, `npm run build`

---

## Start stack

```bash
falcon s:init
```

Starts local replica, deploys the canister, wires `frontend/.env.local`, and runs the Next.js dev server.

---

## Verify

```bash
falcon b:test --local
falcon p:check --local
falcon c:ping --local
```

---

## Scaffold first feature

```bash
falcon m:f Order
falcon b:test --local
falcon b:deploy --local
```

Feature flow: [`integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md)

---

## Hub packages

```bash
falcon p:list
falcon add pkg wallet
```

Hub: https://github.com/prasangapokharel/icp-hub

---

## Related

| Topic | Path |
|---|---|
| Local deploy | [`localDeployStandard/SKILL.md`](../localDeployStandard/SKILL.md) |
| Production deploy | [`productionDeployStandard/SKILL.md`](../productionDeployStandard/SKILL.md) |
| Deploy reference | [`motokoStandard/deployGuideStandard/prerequisites.md`](../../motokoStandard/deployGuideStandard/prerequisites.md) |
| Frontend standard | [`frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
