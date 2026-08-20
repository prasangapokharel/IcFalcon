# Frontend Agent Skills

Router for work under `frontend/`. Master standard: [`.agents/skills/frontendStandard/SKILL.md`](../../.agents/skills/frontendStandard/SKILL.md)

## Task → skill

| Task | Skill |
|---|---|
| Any frontend change | [`../../.agents/skills/frontendStandard/SKILL.md`](../../.agents/skills/frontendStandard/SKILL.md) |
| `lib/` helpers | [`skills/libStandard/SKILL.md`](skills/libStandard/SKILL.md) |
| `hooks/` SWR | [`skills/hooksStandard/SKILL.md`](skills/hooksStandard/SKILL.md) |
| shadcn blocks | [`skills/shadcnBlocksStandard/SKILL.md`](skills/shadcnBlocksStandard/SKILL.md) |
| SWR reference | [`skills/swrOfficialStandard/SKILL.md`](skills/swrOfficialStandard/SKILL.md) |
| Next.js App Router | [`skills/nextjsStandard/SKILL.md`](skills/nextjsStandard/SKILL.md) |

## Cursor rules

Rules are thin pointers — detail lives in skills above.

| Rule | Scope | Skill |
|---|---|---|
| [`rules/uiComponents.mdc`](rules/uiComponents.mdc) | `components/**`, `app/**` | `frontendStandard` |
| [`rules/services.mdc`](rules/services.mdc) | `services/**` | `frontendStandard` |
| [`rules/libStandard.mdc`](rules/libStandard.mdc) | `lib/**` | `libStandard` |
| [`rules/hooksStandard.mdc`](rules/hooksStandard.mdc) | `hooks/**` | `hooksStandard` |
| [`rules/shadcnBlocks.mdc`](rules/shadcnBlocks.mdc) | full sections / shells | `shadcnBlocksStandard` |

## Folders (camelCase)

```
frontend/
├── lib/<feature>/
├── hooks/<feature>/
├── services/<feature>/
├── components/<feature>/
└── components/ui/
```

## Root skills (deploy, setup)

| Task | Path |
|---|---|
| Project setup | [`../../.agents/skills/guideStandard/projectSetupStandard/SKILL.md`](../../.agents/skills/guideStandard/projectSetupStandard/SKILL.md) |
| Local deploy | [`../../.agents/skills/guideStandard/localDeployStandard/SKILL.md`](../../.agents/skills/guideStandard/localDeployStandard/SKILL.md) |
| Production deploy | [`../../.agents/skills/guideStandard/productionDeployStandard/SKILL.md`](../../.agents/skills/guideStandard/productionDeployStandard/SKILL.md) |
