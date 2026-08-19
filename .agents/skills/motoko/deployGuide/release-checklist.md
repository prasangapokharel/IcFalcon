# Release Checklist

## Before merge

- [ ] `falcon b:test --local` green
- [ ] `falcon p:check --local` green
- [ ] New tests in `backend/testing/` if logic changed
- [ ] Migration wired if stable shape changed — [`../../migration/SKILL.md`](../../migration/SKILL.md)
- [ ] `frontend/services/idl.ts` synced if API changed

## Before mainnet upgrade

- [ ] `falcon b:test` green
- [ ] `falcon b:hash` recorded
- [ ] `falcon p:check` green
- [ ] Migration tested: write → upgrade → read
- [ ] Staging/smoke test on identical wasm if possible

## Deploy

```bash
falcon b:deploy
falcon c:ping
falcon p:ship          # if shipping frontend too
```

## After deploy

- [ ] `falcon c:status` — running
- [ ] Health ping OK
- [ ] Critical user flows smoke-tested
- [ ] Frontend env points at new canister id (fresh install only)

## Never

- Deploy untested migrations to mainnet
- Mark storage `transient` inside `persistent actor`
- Skip `falcon b:hash` before upgrade
- Commit `.env`, `*.pem`, `identity.json`
