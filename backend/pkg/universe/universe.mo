import Principal "mo:core/Principal";
import Broker "./broker";
import Inbox "./inbox";
import Outbox "./outbox";
import Types "./types";

module {
  public type Topic = Types.Topic;
  public type EventId = Types.EventId;
  public type Event = Types.Event;
  public type Subscription = Types.Subscription;
  public type DeliveryStatus = Types.DeliveryStatus;
  public type Receipt = Types.Receipt;
  public type NodeInfo = Types.NodeInfo;

  public type Inbox = Inbox.Inbox;
  public type Outbox = Outbox.Outbox;
  public type Broker = Broker.Broker;

  public type Node = {
    inbox : Inbox;
    outbox : Outbox;
    broker : Broker;
    nodeInfo : NodeInfo;
  };

  public func createNode(
    canister : Principal,
    moduleName : Text,
    topicsProduced : [Topic],
    topicsConsumed : [Topic],
    inboxCapacity : Nat,
  ) : Node {
    {
      inbox = Inbox.create(inboxCapacity);
      outbox = Outbox.create(canister);
      broker = Broker.create();
      nodeInfo = {
        canister;
        moduleName;
        topicsProduced;
        topicsConsumed;
      };
    };
  };

  public func publish(
    node : Node,
    id : EventId,
    topic : Topic,
    payload : Text,
    timestamp : Int,
    correlationId : ?Text,
  ) : Event {
    Outbox.enqueue(node.outbox, id, topic, payload, timestamp, correlationId);
  };

  public func consume(node : Node, event : Event) : Bool {
    Inbox.record(node.inbox, event.id);
  };

  public func isProcessed(node : Node, id : EventId) : Bool {
    Inbox.hasProcessed(node.inbox, id);
  };

  public func registerSubscription(node : Node, sub : Subscription) : () {
    Broker.subscribe(node.broker, sub);
  };

  public func routeSubscribers(node : Node, topic : Topic) : [Subscription] {
    Broker.subscribersFor(node.broker, topic);
  };
};
