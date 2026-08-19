---
name: IcFalcon-testingStandard
description: >-
  IcFalcon Motoko testing — run-tests.sh, test layout, migration tests.
  Read before adding or running backend tests.
---

# IcFalcon — Testing Standard

## Run tests

```bash
falcon b:test --local
# or
cd backend && bash scripts/run-tests.sh
```

## Layout

```
backend/testing/
├── services/<Name>Service.test.mo
├── repositories/
├── storage/
└── upgrade/Migration.test.mo
```

Naming: `<Module>.test.mo` — mirror `src/` structure.

## Minimum per feature

- At least one happy-path test in `testing/services/`
- Migration test if stable shape changed

## Before deploy

```bash
falcon b:test --local
falcon p:check --local      # backend + frontend
falcon b:hash --local       # record module hash
falcon b:deploy --local
```

## Related

| Skill | Path |
|---|---|
| Build & test (moc) | [`motoko/buildAndTest/SKILL.md`](../motoko/buildAndTest/SKILL.md) |
| Migration | [`migration/SKILL.md`](../migration/SKILL.md) |
| Integration | [`integrationStandard/SKILL.md`](../integrationStandard/SKILL.md) |
