# Frontend Connection

## Env vars

| Variable | Local | Mainnet |
|---|---|---|
| `NEXT_PUBLIC_CANISTER_ID_APP` | `falcon c:id --local` | production canister id |
| `NEXT_PUBLIC_DFX_NETWORK` | `local` | `ic` |
| `NEXT_PUBLIC_HOST` | `http://127.0.0.1:4943` | `https://icp-api.io` |
| `NEXT_PUBLIC_II_URL` | `https://identity.ic0.app` | same |

## Actor client

- `frontend/services/client.ts` — agent + auth
- `frontend/services/idl.ts` — candid-generated IDL
- `frontend/services/icp.ts` — shared `call()` helper

## IDL sync

After wasm build with new public methods:

1. `falcon b:test --local`
2. Update `frontend/services/idl.ts` from `backend/.dfx/local/canisters/app/app.did` (or `dfx generate`)
3. `falcon f:build`

## Internet Identity

Login flow: `frontend/services/client.ts` + `@dfinity/auth-client`.

Skill: [`../internetIdentityAuth/SKILL.md`](../internetIdentityAuth/SKILL.md)

## Static export

Frontend uses Next.js static export. Deploy `frontend/out/` to any static host after `falcon f:build`.
