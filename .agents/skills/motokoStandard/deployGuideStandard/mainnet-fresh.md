# Mainnet Fresh Install

First-time install of the `app` canister on the Internet Computer.

## Checklist

1. Identity has controller access and enough cycles
2. `falcon b:test` passes
3. `falcon p:check` passes (backend + frontend)
4. Migration modules reviewed — see [`../../migrationStandard/SKILL.md`](../../migrationStandard/SKILL.md)

## Deploy

```bash
falcon b:deploy
```

`falcon` prompts for TTY confirmation on mainnet deploy.

Fresh install (no prior canister id):

```bash
cd backend
dfx deploy app --network ic
```

## Record canister id

```bash
falcon c:id
```

Update production env:

- `NEXT_PUBLIC_CANISTER_ID_APP`
- `NEXT_PUBLIC_DFX_NETWORK=ic`
- `NEXT_PUBLIC_HOST=https://icp-api.io`

## Verify

```bash
falcon c:ping
falcon c:status
falcon c:info
```

## Ship frontend

```bash
falcon p:ship
```

Or build only: `falcon f:build`
