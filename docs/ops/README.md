# Ops

## Architecture

```
ops/
├── falcon                   CLI entry (linked by install.sh)
├── install.sh
├── make-feature.sh          falcon m:f
├── pkg-*.sh                 hub install/list/push
├── scripts/
│   ├── setup-init.sh        falcon s:init
│   └── setup-frontend.sh
└── templates/feature/       scaffold templates

falcon.yaml                  command config at repo root
```

## Use case

One CLI for the full lifecycle — no root `package.json`, no per-repo npm scripts for ops.

## Guide

```bash
./ops/install.sh
falcon help
falcon list
```

| Short | Action |
|---|---|
| `s:init` | Full project setup |
| `m:f Name` | Scaffold module |
| `b:test` | Build canister |
| `b:deploy` | Deploy upgrade |
| `p:check` | Backend + frontend build |
| `add pkg x` | Install hub package |

Full list: [ops/docs/commands.md](../../ops/docs/commands.md)
