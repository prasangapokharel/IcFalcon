---
name: icFalcon-nextjsStandard
description: Next.js App Router conventions for IcFalcon static export frontend.
---

# Next.js

- App Router under `app/`
- Static export: `output: "export"` in `next.config.ts`
- Route groups: `(app)`, `(auth)` — parentheses are not URL segments
- Server Components by default; `"use client"` on leaves only
- No API routes unless explicitly added — canister is the backend
- Images: `unoptimized: true` for static export

Master: [`.agents/skills/frontendStandard/SKILL.md`](../../../../.agents/skills/frontendStandard/SKILL.md)
