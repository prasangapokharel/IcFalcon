# Phase 5 — Extended Deep-Package Backlog

**Objective:** Prioritized backlog for post-Phase-1 hub expansion.

**Timeline:** Month 3+

**Depends on:** [Phase 1](../1/README.md), [Phase 4](../4/README.md) tier labels

---

## Priority legend

| Priority | Meaning |
|---|---|
| P0 | Blocks wallet demo or AI transfers |
| P1 | High adoption demand |
| P2 | Nice-to-have / ecosystem growth |

---

## Backlog

| Package | Import | Purpose | Tier | Priority | Depends on |
|---|---|---|---|---|---|
| `deposit` | `mo:pkg/deposit/deposit` | Sync incoming ledger txs, credit user | L2 | P0 | `wallet`, `transaction` |
| `subaccount` | `mo:pkg/subaccount/subaccount` | Derive, parse, compare subaccounts | L2 | P0 | `icrc1` |
| `icrc21` | `mo:pkg/icrc21/icrc21` | Consent message types for wallets | L2 | P1 | `icrc1` |
| `icrc10` | `mo:pkg/icrc10/icrc10` | Supported standards list | L1 | P2 | — |
| `sns` | `mo:pkg/sns/sns` | SNS neuron / swap hooks | L2 | P2 | `ledger` |
| `icp-identity` | `mo:pkg/icp-identity/icp-identity` | Principal ↔ account mapping | L1 | P1 | `principal` |
| `multisig-transfer` | `mo:pkg/multisig-transfer/multisig-transfer` | N-of-M send approval | L2 | P1 | `transfer`, `multisig` |
| `escrow` | `mo:pkg/escrow/escrow` | Hold until condition (upgrade) | L2 | P1 | `transfer` |
| `swap` | `mo:pkg/swap/swap` | Token A → B quote + execute | L2 | P1 | `icrc1`, `icrc2` |
| `price-oracle` | `mo:pkg/price-oracle/price-oracle` | HTTP outcall + cached price | L2 | P1 | `http-outcall`, `cache` |
| `audit-log` | `mo:pkg/audit-log/audit-log` | Immutable action log | L2 | P1 | `transaction` |
| `ai-action` | `mo:pkg/ai-action/ai-action` | Structured agent action types | L1 | P0 | Phase 2 skill |
| `vetkeys` | `mo:pkg/vetkeys/vetkeys` | vetKD request types (upgrade) | L2 | P2 | — |
| `ckbtc` | `mo:pkg/ckbtc/ckbtc` | ckBTC deposit + transfer (upgrade) | L2 | P1 | `wallet`, `transfer` |
| `wallet-module` | `mo:pkg/wallet-module/wallet-module` | L3 full mixin template | L3 | P1 | all Phase 1 pkgs |

---

## Connector depth upgrades (L1 → L2)

These exist as L1 JSON builders; upgrade when apps need live actor calls:

| Package | Upgrade target |
|---|---|
| `openai` | Streaming + error envelope parse |
| `stripeStandard` | Webhook signature verify integration |
| `sendgrid` / `resend` | Response status mapping |
| `google-oauth` | Token refresh actor call wrapper |

---

## Suggested build order

```
P0: deposit → subaccount → ai-action
P1: ckbtc upgrade → swap → audit-log → wallet-module
P2: sns → icrc10 → vetkeys upgrade
```

---

## Per-package template

When adding any backlog pkg:

```
hub/packages/<name>/
├── icp.pkg.yaml
└── <name>.mo        # < 300 lines, mo:core only
```

1. Register in `hub/index.json` with `tier` + `description`
2. Add skill if L2+ under `.agents/skills/`
3. Add test under `backend/testing/` when installed in a project
4. `falcon p:push <name>` + git push hub

---

## Exit criteria

- All P0 items shipped or explicitly deferred with reason.
- Backlog tracked in hub README or this file with status column.
- `wallet-module` L3 template enables `falcon m:f Wallet` without custom ledger code.

---

## Roadmap complete

Return to [Phase index](../README.md) for vision and timeline.

After Phase 5 P0 items: IcFalcon targets **8.5+ / 10** on wallet and adoption scores.
