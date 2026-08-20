---
name: releaseStandard
description: >-
  Pre-merge and pre-mainnet release checklist for IcFalcon — tests, migrations, deploy, smoke.
---

# Release Standard

Checklist before merging and before shipping to mainnet.

---

## Before merge

- [ ] `falcon sk:validate` green
- [ ] `falcon b:test --local` green
- [ ] `falcon p:check --local` green
- [ ] New tests in `backend/testing/` if logic changed
- [ ] Migration wired if stable shape changed — [`migration/SKILL.md`](../../migrationStandard/SKILL.md)
- [ ] `frontend/services/idl.ts` synced if API changed

---

## Before mainnet

- [ ] `falcon b:test` green
- [ ] `falcon b:hash` recorded
- [ ] `falcon p:check` green
- [ ] Migration tested: write → upgrade → read
- [ ] Staging smoke test on identical wasm when possible

---

## Deploy

```bash
falcon b:deploy
falcon c:ping
falcon p:ship
```

Full flow: [`productionDeployStandard/SKILL.md`](../productionDeployStandard/SKILL.md)

---

## After deploy

- [ ] `falcon c:status` — running
- [ ] Health ping OK
- [ ] Critical user flows smoke-tested
- [ ] Frontend env updated (fresh install only)

---

## Never

- Deploy untested migrations to mainnet
- Mark storage `transient` inside `persistent actor`
- Skip `falcon b:hash` before upgrade
- Commit `.env`, `*.pem`, `identity.json`

---

## Related

| Topic | Path |
|---|---|
| Production deploy | [`productionDeployStandard/SKILL.md`](../productionDeployStandard/SKILL.md) |
| Deploy reference | [`motokoStandard/deployGuideStandard/release-checklist.md`](../../motokoStandard/deployGuideStandard/release-checklist.md) |
| Testing | [`testingStandard/SKILL.md`](../../testingStandard/SKILL.md) |
