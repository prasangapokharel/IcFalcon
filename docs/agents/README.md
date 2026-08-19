# Agents

## Architecture

```
.agents/
├── SKILLS.md                task router
└── skills/
    ├── integrationStandard/
    ├── frontendStandard/
    ├── codingStandard/
    ├── guide/
    │   ├── projectSetupStandard/
    │   ├── localDeployStandard/
    │   ├── productionDeployStandard/
    │   └── releaseStandard/
    └── motoko/

frontend/.agents/            frontend-local skills + cursor rules
```

AI agents read skills before editing code.

## Use case

Consistent codegen across backend and frontend:

- New feature checklist
- Layering and migrations
- shadcn-only UI rules
- Deploy and release workflows

## Guide

Start at [`.agents/SKILLS.md`](../../.agents/SKILLS.md) or root [`AGENTS.md`](../../AGENTS.md).

| Task | Skill |
|---|---|
| New module | `integrationStandard` |
| Frontend UI | `frontendStandard` |
| Project setup | `guide/projectSetupStandard` |
| Local deploy | `guide/localDeployStandard` |
| Production deploy | `guide/productionDeployStandard` |
| Release | `guide/releaseStandard` |
| Deploy reference | `motoko/deployGuide` |
| Logo | `logoStandard` |
