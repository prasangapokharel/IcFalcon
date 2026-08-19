---
name: icFalcon-libStandard
description: IcFalcon frontend lib/ — camelCase modules, pure helpers only.
---

# lib/

Pure TypeScript. No React, no actor, no SWR.

## Layout

```
lib/
├── utils.ts
└── <feature>/
    └── <helper>.ts
```

## Rules

| Rule | Example |
|---|---|
| Folder = feature | `wallet/`, `feature/` |
| File = camelCase | `formatAmount.ts` |
| Import | `@/lib/<feature>/<file>` |
| `cn()` | `@/lib/utils` |

## Belongs here

| lib | services | hooks |
|---|---|---|
| format, parse, constants | canister `call()` | `use*` + SWR |
| validation helpers | `idl.ts` | cache keys |

Master: [`.agents/skills/frontendStandard/SKILL.md`](../../../../.agents/skills/frontendStandard/SKILL.md)
