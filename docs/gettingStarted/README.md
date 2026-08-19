# Getting Started

## Architecture

```
./ops/install.sh  →  falcon CLI on PATH
falcon s:init     →  backend + frontend setup
falcon r:start    →  local ICP replica
falcon b:deploy   →  canister deploy
```

IcFalcon ships one Motoko canister (`app`), a static Next.js frontend, and the global `falcon` CLI.

## Use case

You want a production-shaped ICP app without writing boilerplate:

- Layered Motoko backend
- Internet Identity on the frontend
- Hub packages and module scaffolding

## Guide

**Clone**

```bash
git clone https://github.com/prasangapokharel/IcFalcon.git
cd IcFalcon
```

**Install CLI**

```bash
./ops/install.sh
```

**Initialize**

```bash
falcon s:init
```

**Run locally**

```bash
falcon r:start --local
falcon b:deploy --local
```

**Verify**

```bash
falcon b:test --local
falcon c:ping --local
```

Next: [backend](../backend/README.md) · [frontend](../frontend/README.md)
