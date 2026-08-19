# Local Deploy

## Start replica

```bash
falcon r:start --local
```

## Deploy canister

```bash
falcon b:deploy --local
```

## Health check

```bash
falcon c:ping --local
falcon c:id --local
falcon c:status --local
```

## Frontend

```bash
falcon f:dev
```

Copy `frontend/.env.example` → `frontend/.env.local` and set:

- `NEXT_PUBLIC_CANISTER_ID_APP` — from `falcon c:id --local`
- `NEXT_PUBLIC_DFX_NETWORK=local`
- `NEXT_PUBLIC_HOST=http://127.0.0.1:4943`

Local agent must call `fetchRootKey()` when network is local (handled in `frontend/services/client.ts`).

## Stop replica

```bash
falcon r:stop
```
