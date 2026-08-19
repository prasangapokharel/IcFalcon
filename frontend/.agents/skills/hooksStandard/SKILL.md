---
name: icFalcon-hooksStandard
description: IcFalcon frontend hooks/ — camelCase modules, SWR data hooks only.
---

# hooks/

React + SWR. Canister access stays in `services/`.

## Layout

```
hooks/
└── <feature>/
    └── use<Name>.ts
```

## Rules

| Rule | Example |
|---|---|
| Folder = feature | `feature/`, `wallet/` |
| File = `use` + PascalCase | `useFeature.ts` |
| Import | `@/hooks/<feature>/use<Name>` |
| `"use client"` | only when required |

## Pattern

```typescript
import useSWR from "swr"
import { listFeatures } from "@/services/feature/feature"

export function useFeatures() {
  return useSWR("features", async () => {
    const result = await listFeatures()
    if (!result.ok) throw new Error(result.error)
    return result.data
  })
}
```

SWR docs: [`../swrOfficial/`](../swrOfficial/)

Master: [`.agents/skills/frontendStandard/SKILL.md`](../../../../.agents/skills/frontendStandard/SKILL.md)
