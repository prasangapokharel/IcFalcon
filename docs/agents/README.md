# Agents

## Architecture

```
.agents/
├── SKILLS.md                task router
└── skills/
    ├── integrationStandard/
    ├── frontendStandard/
    ├── codingStandard/
    └── motoko/

frontend/.agents/            frontend-specific rules + SWR docs
```

AI agents read skills before editing code.

## Use case

Consistent codegen across backend and frontend:

- New feature checklist
- Layering and migrations
- shadcn-only UI rules

## Guide

Start at [`.agents/SKILLS.md`](../../.agents/SKILLS.md) or root [`AGENTS.md`](../../AGENTS.md).

| Task | Skill |
|---|---|
| New module | `integrationStandard` |
| Frontend UI | `frontendStandard` |
| Deploy | `motoko/deployGuide` |
| Logo | `logoStandard` |
