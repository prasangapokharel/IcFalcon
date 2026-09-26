import Principal "mo:core/Principal";
import Universe "mo:pkg/universe/universe";

module {
  public func run() : ?Text {
    let mockPrincipal = Principal.fromText("2vxsx-fae");
    let node = Universe.createNode(
      mockPrincipal,
      "order",
      ["order.created", "order.cancelled"],
      ["payment.completed"],
      3 // small capacity to test sliding window
    );

    // 1. Test Outbox sequencing and enqueue
    let event1 = Universe.publish(node, "evt-1", "order.created", "{\"orderId\":\"101\"}", 1000, null);
    if (event1.sequence != 1) {
      return ?("Expected sequence 1, got " # debug_show(event1.sequence));
    };

    let event2 = Universe.publish(node, "evt-2", "order.cancelled", "{\"orderId\":\"101\"}", 1001, null);
    if (event2.sequence != 2) {
      return ?("Expected sequence 2, got " # debug_show(event2.sequence));
    };

    // 2. Test Inbox deduplication (idempotency)
    let firstTime = Universe.consume(node, event1);
    if (not firstTime) {
      return ?("Expected first consumption of evt-1 to return true");
    };

    let secondTime = Universe.consume(node, event1);
    if (secondTime) {
      return ?("Expected duplicate consumption of evt-1 to return false");
    };

    // 3. Test Broker topic routing & wildcard matching
    let billingPrincipal = Principal.fromText("aaaaa-aa");
    Universe.registerSubscription(node, {
      id = "sub-billing";
      subscriber = billingPrincipal;
      topic = "order.*";
      endpoint = "onEvent";
      filter = null;
    });

    let targets1 = Universe.routeSubscribers(node, "order.created");
    if (targets1.size() != 1) {
      return ?("Expected 1 subscriber for order.created, got " # debug_show(targets1.size()));
    };

    let targets2 = Universe.routeSubscribers(node, "order.cancelled");
    if (targets2.size() != 1) {
      return ?("Expected 1 subscriber for order.cancelled, got " # debug_show(targets2.size()));
    };

    let targets3 = Universe.routeSubscribers(node, "user.created");
    if (targets3.size() != 0) {
      return ?("Expected 0 subscribers for user.created, got " # debug_show(targets3.size()));
    };

    null;
  };
};
