# Phase 4 — Hub Depth Tiers

**Objective:** Label every hub package so adopters know depth at install time.

**Timeline:** Month 3

**Depends on:** [Phase 1](../1/README.md) (L2 pkgs must exist to label them)

---

## Tier definitions

| Tier | Name | Contains | Use when |
|---|---|---|---|
| **L1** | Types | Config, JSON builders, validators | Connector setup, no ledger |
| **L2** | ICP native | Actor calls, error codes, fee logic | Wallet, transfer, ICRC |
| **L3** | Full module | Storage + service + api mixin template | Drop-in feature module |

---

## Examples

| Package | Tier | Notes |
|---|---|---|
| `openai` | L1 | Config + chat body builder |
| `emailStandard` | L1 | Message types + validation |
| `slack` | L1 | Form body + auth header |
| `http-outcall` | L1 | Request types + size caps |
| `wallet` | L2 | Custodial account + balance |
| `transfer` | L2 | ICRC transfer + idempotency |
| `icrc1` | L2 | Full TransferArgs + errors |
| `transaction` | L2 | Tx record + history |
| `wallet-module` | L3 | Future — full mixin template |

---

## Hub README updates

Update [hub/README.md](../../../hub/README.md):

1. Add **Tier** column to every package table.
2. Group tables: L1 Connectors, L2 ICP Money, L3 Modules.
3. Install note per tier:

```bash
# L1 — use in your service layer
falcon add pkg openai

# L2 — read phase 1 docs first
falcon add pkg wallet

# L3 — includes scaffold mixin
falcon add pkg wallet-module
```

4. Link to [docs/phase/1/README.md](../1/README.md) from L2 section.

---

## index.json metadata (optional)

Extend `hub/index.json` entries:

```json
"wallet": {
  "version": "2.0.0",
  "tier": "L2",
  "description": "Custodial wallet account and balance",
  "path": "packages/wallet",
  "import": "mo:pkg/wallet/wallet"
}
```

`falcon p:list` can display tier when metadata present.

---

## Deliverables checklist

- [ ] Tier column in hub README tables
- [ ] All Phase 1 pkgs marked L2
- [ ] All connector pkgs (openai, slack, email, etc.) marked L1
- [ ] `tier` field in index.json for new/updated pkgs
- [ ] Phase 5 backlog items tagged P0/P1/P2 + target tier

---

## Exit criteria

- Adopter can choose correct pkg depth without reading source.
- L2 money pkgs link to ledger integration skill.
- No L1 pkg claims to perform ledger transfers.

---

## Next phase

[Phase 5 — Extended package backlog](../5/README.md)
