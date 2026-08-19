---
name: IcFalcon-localDeployStandard
description: >-
  Local replica deploy for IcFalcon — start replica, deploy canister, wire frontend env, dev server.
---

# Local Deploy Standard

Run the full stack on a local Internet Computer replica.

## Quick flow

```bash
falcon r:start --local
falcon b:test --local
falcon b:deploy --local
falcon c:ping --local
falcon f:dev
```

---

## Start replica

```bash
falcon r:start --local
```

Stop when done:

```bash
falcon r:stop
```

---

## Deploy canister

```bash
falcon b:test --local
falcon b:deploy --local
```

Health:

```bash
falcon c:ping --local
falcon c:id --local
falcon c:status --local
```

---

## Frontend env

Copy `frontend/.env.example` → `frontend/.env.local`:

- `NEXT_PUBLIC_CANISTER_ID_APP` — from `falcon c:id --local`
- `NEXT_PUBLIC_DFX_NETWORK=local`
- `NEXT_PUBLIC_HOST=http://127.0.0.1:4943`

Local network calls `fetchRootKey()` in `frontend/services/client.ts`.

---

## Full check

```bash
falcon p:check --local
```

---

## Related

| Topic | Path |
|---|---|
| Project setup | [`projectSetupStandard/SKILL.md`](../projectSetupStandard/SKILL.md) |
| Production deploy | [`productionDeployStandard/SKILL.md`](../productionDeployStandard/SKILL.md) |
| Deploy reference | [`motoko/deployGuide/local-deploy.md`](../../motoko/deployGuide/local-deploy.md) |
| Frontend env | [`motoko/deployGuide/frontend-connection.md`](../../motoko/deployGuide/frontend-connection.md) |
