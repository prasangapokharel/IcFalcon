# Mainnet Upgrade

Upgrade an existing `app` canister while preserving stable state.

## Before upgrade

1. Read [`../../migrationStandard/SKILL.md`](../../migrationStandard/SKILL.md) if any record shape changed
2. `falcon b:test` — build must pass
3. `falcon b:hash` — record current module hash
4. `falcon p:check` — backend + frontend

## Upgrade

```bash
falcon b:deploy
```

This runs `dfx build` + `dfx deploy app --mode=upgrade`.

## Verify

```bash
falcon c:ping
falcon c:status
```

Run domain-specific queries and confirm persisted data survived.

## Migration test (required when schema changed)

```bash
dfx canister call app <writeMethod> '(...)'
falcon b:deploy --local    # or mainnet upgrade on staging first
dfx canister call app <readMethod>   # must NOT be null
```

## Rollback

Keep the previous wasm hash from `falcon b:hash`. Re-install only if you have a known-good wasm and controller access — prefer forward-fix migrations.

## Flow

```
falcon b:test → falcon b:hash → falcon b:deploy → falcon c:ping → smoke tests
```
