---
name: migrationTroubleshootingStandard
description: >-
  Deep reference when the migration chain misbehaves — compatibility errors,
  frozen files, converted projects, or requests to remove the chain. Load only
  when migratingMotoko / migration skills do not explain what you see.
---

# Migration Troubleshooting

Failure modes of the mops-managed migration chain (`backend/src/migrations/`).

**Do not load for routine work.** Authoring migrations is covered by
[`../migratingMotokoStandard/SKILL.md`](../migratingMotokoStandard/SKILL.md),
[`../migratingMotokoEnhancedStandard/SKILL.md`](../migratingMotokoEnhancedStandard/SKILL.md),
and [`../../migrationStandard/SKILL.md`](../../migrationStandard/SKILL.md).

Come here when:

- a compatibility diagnostic does not match `main.mo`
- a write to a migration file fails, or you want to rename/delete one
- the first chain file has a non-empty `OldActor` and you are unsure if that is correct
- the task asks to remove migrations or restore inline initializers
- `mops check` complains about state not in current source

---

## How the runtime decides what to run

- The whole chain compiles into the backend wasm — no separate artifacts.
- Applied migrations are tracked **by module name** (filename without `.mo`).
- On **upgrade**, only not-yet-applied migrations replay. Deploying several
  versions behind replays all missing steps in one upgrade.
- On **fresh install**, every file replays in lexicographic order — forever.

Consequences:

- **Renaming a migration changes its identity** — never rename applied files.
- **Editing an applied migration is invisible** to canisters that already ran it.
  Fix forward with a new migration (`IC0503` missing field traps otherwise).

---

## What the checker compares

`mops check` validates against the **deployed** canister's stable signature
(`.most` snapshot), not git history.

- Diagnostics may name fields no longer in source — they come from deployed wasm.
- One-pending-migration limit counts migrations **not yet deployed**.
- Stable-signature major: `1` classic, `3` legacy inline, `4` enhanced chain.
  Enhanced migration is one-way — no downgrade.

---

## Diagnostics

| Code | Meaning | Action |
|---|---|---|
| `M0250` | Stable field has inline initializer | Typed declaration only; value in pending migration `NewActor` |
| `M0254` / `M0267` | Field declared but no migration supplies it | Add to pending migration `NewActor` |
| `M0170` | Not stable-compatible with deployed signature | Add/extend pending migration |
| `M0255` | Signature downgrade attempted | Restore chain — no supported downgrade |
| Chain start mismatch | First `OldActor` ≠ actual canister state | See [Converted projects](#converted-projects) |
| `IC0503` | Runtime missing stable field | New migration — never edit old file |
| `IC0505` | Custom section too large (install only) | Chain too long — see [Short chains](#keep-chains-short) |

---

## Frozen migration files

After successful deploy, applied migrations may be read-only. Do not `chmod`,
delete, rename, or bypass the write failure.

- Edit the **current build's** pending migration if it is not yet deployed.
- Changes to frozen history → new migration that transforms current state forward.

---

## Converted projects

Projects converted from legacy inline `(with migration = …)` to enhanced chain:

- First file is often an **identity migration** with non-empty `OldActor` —
  correct; do not simplify to `{}`.
- `OldActor = {}` only when the chain started from an empty canister.
- Never prune pre-conversion history — fresh installs replay from legacy shape.

---

## Keep chains short

Long chains become undeployable:

- Custom section encoding stable-type history has a ~1 MiB platform limit
  (`IC0505` at install — build/check may still pass).
- Every file replays on every fresh install in a single message.
- Fold changes into the single pending migration per deploy.

---

## Static actor body

Actor body must not seed stable state. Values come from migrations or lazy
idempotent logic inside update methods. Top-level seeding re-runs on upgrade
and overwrites live data.

---

## When you cannot resolve

Do not relax config, delete history, or rewrite frozen files. Report: checker
field names, latest migration `NewActor`, and `main.mo` declarations.

---

## Related

| Topic | Path |
|---|---|
| Inline migration | [`../migratingMotokoStandard/SKILL.md`](../migratingMotokoStandard/SKILL.md) |
| Enhanced chain | [`../migratingMotokoEnhancedStandard/SKILL.md`](../migratingMotokoEnhancedStandard/SKILL.md) |
| IcFalcon workflow | [`../../migrationStandard/SKILL.md`](../../migrationStandard/SKILL.md) |
