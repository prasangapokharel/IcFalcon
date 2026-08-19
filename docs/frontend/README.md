# Frontend

## Architecture

```
frontend/
├── app/                     App Router, static export
├── components/
│   ├── ui/                  shadcn primitives
│   └── <feature>/           feature panels
├── services/                canister client (client.ts, idl.ts)
├── hooks/                   SWR (optional)
├── lib/                     pure helpers
└── public/brand/logo.png
```

Stack: Next.js 15, Tailwind v4, shadcn `base-maia`, Internet Identity.

## Use case

Static SPA that talks to the `app` canister:

- Welcome / marketing shell
- Auth via Internet Identity
- Feature panels per `falcon m:f` module

## Guide

Setup runs on `falcon s:init` (npm install, shadcn `--all`, `npm run build`).

```bash
falcon f:dev                # local dev (optional)
npm run build --prefix frontend
```

UI rules: shadcn only, camelCase folders — `.agents/skills/frontendStandard/SKILL.md`

Brand: `public/brand/logo.png`, favicon `app/icon.png`
