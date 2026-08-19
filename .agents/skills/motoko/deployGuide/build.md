# Build

## Standard build

```bash
falcon b:test --local          # local
falcon b:test                  # mainnet wasm (no deploy)
falcon b:build --local         # same as b:test
```

Runs `dfx build app` from `backend/` (configured in `falcon.yaml`).

## Run Motoko tests

```bash
falcon b:test --local
# or
cd backend && bash scripts/run-tests.sh
```

Tests live in `backend/testing/**/*.test.mo`. Do **not** use `mops test` — it looks in `test/`.

## Candid / IDL

After adding or changing public actor methods:

1. `falcon b:test --local`
2. Copy generated candid → update `frontend/services/idl.ts`
3. `falcon f:build` or `falcon p:check`

Generated artifacts: `backend/.dfx/local/canisters/app/`

## dfx.json

```json
{
  "canisters": {
    "app": {
      "main": "src/main.mo",
      "type": "motoko",
      "args": "--package pkg pkg"
    }
  }
}
```

## Pre-deploy

```bash
falcon b:test --local
falcon p:check --local
falcon b:hash --local
```
