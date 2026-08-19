---
name: icFalcon-frontendStandard
description: >-
  IcFalcon Next.js frontend — shadcn/ui only, camelCase folders, services/hooks/lib
  layering, static export, Internet Identity. Read before any frontend change.
---

# IcFalcon — Frontend Standard

Next.js App Router, static export, shadcn preset `base-maia`. All UI through shadcn.
No raw Tailwind on feature UI except rare layout tweaks via `cn()` on shadcn components.

Local detail skills: [`frontend/.agents/SKILLS.md`](../../../frontend/.agents/SKILLS.md)

---

## Layout

```
frontend/
├── app/
│   ├── layout.tsx
│   ├── globals.css          theme tokens only — no feature styles
│   └── (app)/
│       └── page.tsx
├── components/
│   ├── ui/                  shadcn primitives only
│   ├── auth/
│   │   └── AuthProvider.tsx
│   └── <feature>/
│       └── <Feature>Panel.tsx
├── hooks/
│   └── <feature>/
│       └── use<Feature>.ts
├── lib/
│   ├── utils.ts             cn() — shadcn alias
│   └── <feature>/
│       └── <helper>.ts
├── services/
│   ├── client.ts            actor factory + call()
│   ├── idl.ts               candid IDL
│   ├── icp.ts               host, canisterId, iiUrl
│   └── <feature>/
│       └── <feature>.ts
├── components.json
└── .agents/                 frontend-local skill index
```

---

## Naming

| Item | Rule | Example |
|---|---|---|
| Folders | camelCase | `feature`, `auth`, `ui` |
| Component files | PascalCase | `FeaturePanel.tsx` |
| Hook files | camelCase, `use` prefix | `useFeature.ts` |
| Service files | camelCase | `feature.ts` |
| Lib files | camelCase | `formatAmount.ts` |
| Exports | named only | no `export default` |

Max ~300 lines per file. Split by concern when larger.

---

## shadcn/ui only

Setup installs every component automatically:

```bash
falcon s:init
```

Runs `npx shadcn@latest add --all` via `ops/scripts/setup-frontend.sh`.

Manual add:

```bash
cd frontend && npx shadcn@latest add button card input
```

| Need | Use |
|---|---|
| Button, input, form | `@/components/ui/*` |
| Page sections | shadcn blocks CLI first |
| Spacing tweak | `cn()` on shadcn component `className` |
| Icons | `lucide-react` (preset default) |

Forbidden on feature UI:

- Raw `<button>`, `<input>`, `<div className="flex gap-4 ...">` layouts that duplicate Card, Stack, or block patterns
- Custom CSS files for components
- Inline `style={{}}` except unavoidable browser APIs

Allowed Tailwind:

- `cn("w-full")` on shadcn `Button`, `Card`, etc.
- `className` on `html` / `body` in root layout
- Theme variables in `app/globals.css`

Full sections (auth, sidebar shell, dashboard): install a block, move feature parts to `components/<feature>/`, wire services — see [`frontend/.agents/skills/shadcnBlocks/SKILL.md`](../../../frontend/.agents/skills/shadcnBlocks/SKILL.md).

---

## Layer rules

```
app/page  →  components/<feature>  →  hooks/<feature>  →  services/<feature>
                                      ↘  lib/<feature>
```

| Layer | Path | Contains |
|---|---|---|
| `services/` | canister calls | `call()`, actor methods, `Outcome<T>` |
| `hooks/` | client data | SWR, `use*` + `"use client"` when needed |
| `lib/` | pure TS | format, parse, constants — no React, no actor |
| `components/ui/` | shadcn | generated primitives only |
| `components/<feature>/` | feature UI | composes ui + hooks |

Never create `HttpAgent` outside `services/client.ts`.
Never call the actor from a component — go through `services/<feature>/`.

---

## services/

Shared root:

- `client.ts` — `createActor`, `call`, `Outcome<T>`
- `idl.ts` — sync after `falcon b:test` when API changes
- `icp.ts` — `host`, `canisterId`, `iiUrl`

Per feature (`falcon m:f` scaffolds `services/<name>/<name>.ts`):

```typescript
import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"

export function createOrder(identity: Identity | undefined, name: string) {
  return call(identity, "Create failed", (actor) => actor.createOrder(name))
}
```

Named async functions only. Return `Outcome<T>` from `call()`.

---

## hooks/

One folder per feature. SWR for reads; mutations call services then `mutate`.

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

Import: `@/hooks/<feature>/use<Name>`

SWR reference: [`frontend/.agents/skills/swrOfficial/`](../../../frontend/.agents/skills/swrOfficial/)

---

## lib/

Pure helpers. Import: `@/lib/<feature>/<file>` or `@/lib/utils` for `cn`.

No React, no `@dfinity/*`, no SWR.

---

## components/

Feature components: `components/<feature>/<Name>.tsx`

```tsx
"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { cn } from "@/lib/utils"

export function FeaturePanel({ className }: { className?: string }) {
  return (
    <Card className={cn(className)}>
      <CardHeader>
        <CardTitle>Feature</CardTitle>
      </CardHeader>
      <CardContent>
        <Button type="button">Save</Button>
      </CardContent>
    </Card>
  )
}
```

Default to Server Components. `"use client"` on the smallest leaf that needs state or events.

---

## app/

Static export (`output: "export"`). Route groups: `app/(app)/`, `app/(auth)/`.

Pages compose feature components — no business logic in `page.tsx`.

Env: `frontend/.env.example` — `NEXT_PUBLIC_CANISTER_ID_APP`, `NEXT_PUBLIC_DFX_NETWORK`, `NEXT_PUBLIC_HOST`, `NEXT_PUBLIC_II_URL`.

---

## Code style

- No comments in source files
- Self-explanatory names over annotations
- No commented-out code
- No `fetch()` in components
- No duplicate shadcn primitives — use `components/ui/`

---

## New feature checklist

1. `falcon m:f <Name>` — backend + service + panel scaffold
2. Update `services/idl.ts` if actor API changed
3. Add shadcn components: `npx shadcn@latest add …`
4. Replace scaffold panel raw HTML with shadcn `Card`, `Button`, `Input`
5. Optional `hooks/<name>/use<Name>.ts` for SWR
6. Optional `lib/<name>/` for pure formatters
7. `falcon f:build` — must pass

---

## Related

| Topic | Path |
|---|---|
| Frontend local index | [`frontend/.agents/SKILLS.md`](../../../frontend/.agents/SKILLS.md) |
| lib detail | [`frontend/.agents/skills/libStandard/SKILL.md`](../../../frontend/.agents/skills/libStandard/SKILL.md) |
| hooks detail | [`frontend/.agents/skills/hooksStandard/SKILL.md`](../../../frontend/.agents/skills/hooksStandard/SKILL.md) |
| shadcn blocks | [`frontend/.agents/skills/shadcnBlocks/SKILL.md`](../../../frontend/.agents/skills/shadcnBlocks/SKILL.md) |
| Full feature flow | [`../integrationStandard/SKILL.md`](../integrationStandard/SKILL.md) |
| II auth | [`../motoko/internetIdentityAuth/SKILL.md`](../motoko/internetIdentityAuth/SKILL.md) |
| Deploy / env | [`../motoko/deployGuide/frontend-connection.md`](../motoko/deployGuide/frontend-connection.md) |
