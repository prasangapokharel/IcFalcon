---
name: falconUniverseStandard
description: >-
  Multi-canister event-driven architecture ("Kafka for Motoko") — modular canisters,
  pub/sub event mesh, topic routing, outbox pattern, idempotency, and high-scale canister partitioning.
---

# Falcon Universe — Multi-Canister Event Mesh

Architecture standard for building scalable, multi-canister Internet Computer backends using asynchronous event-driven messaging ("Kafka for Motoko").

---

## Purpose

Single canisters face physical compute and memory boundaries (4GB stable memory limits, instruction cycles per message). As applications scale, business modules (e.g. Identity, Wallet, Orders, Notifications, Analytics) must be split into independent canisters.

Falcon Universe eliminates tight, brittle inter-canister coupling by introducing a decentralized event bus:
- **Topics & Subscriptions**: Canisters publish named events (`order.created`, `wallet.deposited`) without knowing who consumes them.
- **Transactional Outbox**: Events are persisted and ordered monotonically before dispatch, preventing loss on trapped calls.
- **Idempotent Inbox**: Consumers track processed event IDs within a bounded sliding window, neutralizing duplicate transmissions.
- **Cycle & Deadlock Protection**: Asynchronous notification eliminates cyclic wait-states and deadlocks.

---

## When to use

- Partitioning a monolith canister into domain-specific micro-canisters
- Decoupling independent services (e.g., checkout emitting events consumed by inventory and billing)
- Reliable asynchronous background processing between canisters
- Preventing inter-canister reentrancy and bidirectional call deadlocks
- Building event streaming or audit logging across canisters

---

## Architecture

```
[ Producer Canister ]
        │ (1. commit state + outbox)
   ┌────▼────────┐
   │   Outbox    │ ──(seq: 1, 2, 3...)
   └────┬────────┘
        │ (2. async publish)
        ▼
   [ Topic Broker / Event Mesh ] ── ("order.*")
        │
   ┌────┴────────┐
   │             │ (3. route event)
   ▼             ▼
[ Canister A ] [ Canister B ]
   │ (Inbox dedupe)
   ▼ (Execute handler)
```

Canisters communicate via standard `Event` envelopes:

```motoko
public type Event = {
  id : Text;            // Unique UUID or nanoid
  topic : Text;         // e.g. "order.created"
  source : Principal;   // Origin canister
  timestamp : Int;      // Time.now()
  sequence : Nat;       // Monotonic outbox sequence
  payload : Text;       // JSON payload
  correlationId : ?Text;// Distributed trace ID
};
```

---

## Implementation Patterns

### 1. Producer: Transactional Outbox

Always record the state mutation and enqueue the event in the same atomic block. Never make cross-canister calls inside the primary update transaction:

```motoko
import Universe "pkg/universe/universe";

actor {
  var outbox = Universe.createOutbox(Principal.fromActor(this));

  public shared ({ caller }) func createOrder(item : Text) : async Result<Text, Text> {
    // 1. Mutate local domain state
    let orderId = recordOrder(caller, item);

    // 2. Enqueue event in outbox
    let event = Universe.publish(
      node,
      orderId,
      "order.created",
      item,
      Time.now(),
      null
    );

    // 3. Trigger async dispatch (fire-and-forget or cron task)
    ignore dispatchPending();

    #ok(orderId);
  };
};
```

---

### 2. Consumer: Idempotent Inbox

Network retries or canister restarts can cause duplicate delivery. The consumer checks its inbox before applying state changes:

```motoko
import Universe "pkg/universe/universe";

actor {
  let inbox = Universe.createInbox(1000); // 1,000 item deduplication window

  public shared ({ caller }) func onEvent(event : Universe.Event) : async () {
    // Deduplication check
    if (not Universe.consume(node, event)) {
      return; // Already processed
    };

    // Apply domain handler
    switch (event.topic) {
      case ("order.created") { handleOrder(event.payload) };
      case (_) {};
    };
  };
};
```

---

### 3. Broker: Topic Routing

Subscribers register with exact topic names or wildcards (`"order.*"`, `"*"`):

```motoko
let broker = Universe.createBroker();

Universe.subscribe(broker, {
  id = "billing-order-sub";
  subscriber = billingCanisterPrincipal;
  topic = "order.*";
  endpoint = "onEvent";
  filter = null;
});

// Routing query matches both "order.created" and "order.cancelled"
let targets = Universe.subscribersFor(broker, "order.created");
```

---

## Hub Package (`pkg/universe`)

Install into your backend canister via Falcon CLI:

```bash
falcon add pkg universe
```

Modules provided:
- `pkg/universe/universe` — Facade and `Node` constructor
- `pkg/universe/types` — `Event`, `Subscription`, `Receipt`, `Topic`
- `pkg/universe/outbox` — Monotonic outbox queue and sequencing
- `pkg/universe/inbox` — Bounded-capacity sliding-window idempotency tracker
- `pkg/universe/broker` — Wildcard topic routing engine

---

## Rules

1. **No Sync Cycles**: Never await a call to a canister that directly or indirectly awaits back on you (deadlock).
2. **Outbox First**: Persist events locally before emitting across canisters.
3. **Idempotent Consumers**: Every consumer must verify event IDs against an inbox before mutating state.
4. **Bounded Payloads**: Keep event payloads under 2MB (IC message boundary limit). Use object storage (`objectStorageStandard`) for large blobs.
5. **Caller Authorization**: Event endpoints must check that `caller` is an authorized broker or known producer canister.

---

## Related

| Topic | Path |
|---|---|
| Canister calls | [`layeringStandard/SKILL.md`](../layeringStandard/SKILL.md) |
| Feature integration | [`integrationStandard/SKILL.md`](../integrationStandard/SKILL.md) |
| Error handling | [`errorHandlingStandard/SKILL.md`](../errorHandlingStandard/SKILL.md) |
| Object storage | [`extensionsStandard/objectStorageStandard/SKILL.md`](../extensionsStandard/objectStorageStandard/SKILL.md) |
| Webhooks | [`extensionsStandard/stripeStandard/SKILL.md`](../extensionsStandard/stripeStandard/SKILL.md) |
