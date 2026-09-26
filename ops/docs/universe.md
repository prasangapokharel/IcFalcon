# Falcon Universe — Multi-Canister Event Mesh

**Falcon Universe** provides an asynchronous, event-driven pub/sub architecture ("Kafka for Motoko") to horizontally partition Internet Computer micro-canisters.

---

## 1. Why Falcon Universe?

As dapps on the Internet Computer scale, keeping all logic in a single canister encounters limits in cycle limits, upgrade pauses, and tight coupling.

Falcon Universe decouples canisters via pub/sub messaging:

```
┌─────────────────┐                       ┌───────────────────┐
│  Order Canister │                       │ Payment Canister  │
│  (Publisher)    │                       │  (Subscriber)     │
└────────┬────────┘                       └─────────▲─────────┘
         │                                          │
         │ 1. outbox.enqueue(event)                 │ 4. inbox.recordProcessed(eventId)
         │ 2. notify / push                         │    (Idempotent deduplication)
         ▼                                          │
┌───────────────────────────────────────────────────┴─────────┐
│                    Falcon Universe Mesh                     │
│  - Wildcard Topic Routing (e.g. "order.*", "*")             │
│  - Monotonic Sequence Ordering (seq)                        │
│  - Sliding Window Deduplication (Inbox)                     │
│  - High-Throughput Queue Outbox                             │
│  - Background IC Timer Heartbeats                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Components (`mo:pkg/universe/universe`)

Install package via:
```bash
falcon add pkg universe
```

### Transactional Outbox (`outbox.mo`)
Guarantees at-least-once message delivery:
- **Monotonic Sequence**: Automatically assigns an incrementing `sequence: Nat` to every outbound event.
- **`mo:core/Queue` Backing**: Uses a doubly-linked list for `O(1)` amortized enqueue and `O(1)` sequential consumption (`popNext`).
- **Targeted Acknowledgment**: `acknowledge(outbox, eventId)` removes processed items without array re-allocations.
- **Timer Flush Hooks**: `scheduleFlush` and `startHeartbeat` trigger automatic background flushing.

### Idempotent Inbox (`inbox.mo`)
Guarantees exactly-once execution semantics:
- **Sliding-Window Deduplication**: Tracks recently received `EventId`s in memory.
- If network retries resend an event, `Inbox.record(inbox, eventId)` returns `false` to safely reject duplicates.

### Broker & Wildcard Topic Routing (`broker.mo`)
Hierarchical event routing:
- **Exact Match**: `"order.created"`
- **Prefix Wildcard**: `"order.*"` (matches `order.created`, `order.cancelled`)
- **Global Wildcard**: `"*"` (receives all events for auditing and analytics)

---

## 3. Usage Example

### Initializing a Universe Node

```motoko
import Universe "mo:pkg/universe/universe";
import Principal "mo:core/Principal";

persistent actor self {
  let myPrincipal = Principal.fromActor(self);

  // Initialize a Universe Node with a 1,000-event deduplication window
  let universeNode = Universe.createNode(
    myPrincipal,
    "OrderCanister",
    ["order.created", "order.cancelled"], // Produced topics
    ["payment.completed"],                 // Consumed topics
    1000                                  // Deduplication window size
  );
};
```

### Publishing an Event (Transactional Outbox)

```motoko
let event = Universe.publish(
  universeNode,
  "evt-101",
  "order.created",
  "{\"orderId\": \"ORD-998\", \"amount\": 5000}",
  Time.now(),
  null
);
```

### Consuming an Event (Idempotent Inbox)

```motoko
public shared ({ caller }) func onUniverseEvent(event : Universe.Event) : async Universe.Receipt {
  // Idempotency check: returns false if already processed
  if (not Universe.consume(universeNode, event)) {
    return {
      eventId = event.id;
      status = #rejected;
      error = ?"Duplicate event detected";
    };
  };

  // Safe to process business logic once
  await processPayment(event.payload);

  {
    eventId = event.id;
    status = #acknowledged;
    error = null;
  };
};
```

### Registering Subscriptions

```motoko
Universe.registerSubscription(universeNode, {
  id = "sub-order-wildcard";
  subscriber = paymentCanisterPrincipal;
  topic = "order.*";
  endpoint = "onUniverseEvent";
  filter = null;
});

// Route subscribers for an event
let targets = Universe.routeSubscribers(universeNode, "order.created");
```

---

## 4. Background Timer Heartbeat

Install an automated flush heartbeat in your canister actor:

```motoko
import Timer "mo:core/Timer";
import Time "mo:core/Time";

// Automatically flush pending outbox events every 5 seconds
let timerId = Universe.Outbox.startHeartbeat<system>(
  universeNode.outbox,
  #seconds 5,
  flushPendingEvents
);
```
