# IcFalcon Documentation Hub

Welcome to the official developer documentation for **IcFalcon** — an enterprise-grade full-stack framework for building applications on the Internet Computer (ICP).

---

## Documentation Index

| Guide | Description |
|---|---|
| [**Commands Reference**](commands.md) | Complete CLI reference for `falcon`, all aliases, shortcuts, and custom tasks |
| [**Architecture Guide**](architecture.md) | 4-tier Motoko backend (`api → services → repositories → storage`), persistent memory, and error handling |
| [**Falcon Universe**](universe.md) | Multi-canister event mesh ("Kafka for Motoko") — Outbox, Inbox deduplication, Broker routing, and Timer heartbeats |
| [**Code Validator & Linter**](audit.md) | Style, consistency, and architecture layering validator (`falcon audit code:motoko` / `falcon a:c:m`) |
| [**Package Ecosystem**](packages.md) | `icp-hub` package manager (`falcon add pkg <name>`), 65+ audited Motoko packages, and publishing |
| [**Money & Payments Layer**](finance.md) | ICPay integration, subaccount derivation, ICRC-1 / ICRC-2 ledger, custodial wallets, and controller management |
| [**Frontend Architecture**](frontend.md) | Next.js 15, `@icp-sdk/core` & `@icp-sdk/auth`, Internet Identity modal, and static asset canister export |

---

## Quick Start

```bash
# 1. Install CLI globally
./ops/install.sh

# 2. Initialize project (installs dependencies, builds frontend & backend)
falcon s:init

# 3. Scaffold a new module (Laravel-style)
falcon m:f Order

# 4. Audit code consistency
falcon a:c:m

# 5. Run tests & build
falcon b:test --local

# 6. Production pre-flight check
falcon p:check --local
```

---

## Core Principles

1. **Strict Layering**: Business logic lives exclusively in `services/`, never in `api/` or `storage/`.
2. **Orthogonal Persistence**: Motoko `persistent actor` ensures memory state survives canister upgrades automatically.
3. **Decoupled Event Mesh**: High-throughput inter-canister communication via Falcon Universe pub/sub messaging.
4. **Zero Legacy Dependencies**: Pure `@icp-sdk` on frontend and `mo:core` (2.x) on backend.
5. **AI-Ready Standards**: Complete library of 52 structured skills in `.agents/skills/` for AI pair programming.
