---
name: logoStandard
description: >-
  IcFalcon brand — logo asset and favicon paths. Use when updating logo,
  favicon, or home page branding.
---

# Logo Standard

## Purpose

Single source for brand asset paths.

## When to use

- Replace logo or favicon
- Add branding to a new page

## Assets

| Asset | Path |
|---|---|
| Logo | `frontend/public/brand/logo.png` |
| Favicon | `frontend/app/icon.png` (copy of logo — Next.js auto-serves) |

Home welcome: `frontend/app/(app)/page.tsx` — logo avatar + "Welcome to IcFalcon".

Update both `public/brand/logo.png` and `app/icon.png` together.

## Related

| Task | Skill |
|---|---|
| Frontend layout | [`../frontendStandard/SKILL.md`](../frontendStandard/SKILL.md) |
