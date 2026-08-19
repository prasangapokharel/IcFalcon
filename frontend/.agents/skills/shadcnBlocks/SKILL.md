---
name: icFalcon-shadcnBlocks
description: Install shadcn blocks via CLI for full sections; wire to services.
---

# shadcn Blocks

Blocks: https://ui.shadcn.com/blocks

## Flow

1. Pick block on the site — verify exact CLI name
2. Run inside `frontend/`:
   ```bash
   npx shadcn@latest add sidebar-06
   npx shadcn@latest add login-04
   ```
3. Move feature parts to `components/<feature>/`
4. Keep primitives in `components/ui/`
5. Wire handlers to `services/<feature>/`

## Do

- CLI install, then adapt data
- Default shadcn styling + `cn()` tweaks only

## Do not

- Hand-build sidebar/login/table from raw divs + Tailwind
- Copy block markup from the website
- Restyle block internals — use props and `cn()`

Master: [`.agents/skills/frontendStandard/SKILL.md`](../../../../.agents/skills/frontendStandard/SKILL.md)
