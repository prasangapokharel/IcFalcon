import Array "mo:core/Array";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Types "./types";

module {
  public type Broker = {
    var subscriptions : [Types.Subscription];
  };

  public func create() : Broker {
    {
      var subscriptions = [];
    };
  };

  public func topicMatches(pattern : Types.Topic, topic : Types.Topic) : Bool {
    if (pattern == "*" or pattern == topic) {
      return true;
    };
    if (Text.endsWith(pattern, #text ".*")) {
      var parts = Text.split(pattern, #text ".*");
      switch (parts.next()) {
        case (?prefix) {
          if (Text.startsWith(topic, #text prefix)) {
            return true;
          };
        };
        case (null) {};
      };
    };
    false;
  };

  public func subscribe(broker : Broker, sub : Types.Subscription) : () {
    var updated : [Types.Subscription] = [];
    var replaced = false;
    var i = 0;
    while (i < broker.subscriptions.size()) {
      let existing = broker.subscriptions[i];
      if (existing.id == sub.id) {
        updated := Array.concat<Types.Subscription>(updated, [sub]);
        replaced := true;
      } else {
        updated := Array.concat<Types.Subscription>(updated, [existing]);
      };
      i += 1;
    };
    if (not replaced) {
      updated := Array.concat<Types.Subscription>(updated, [sub]);
    };
    broker.subscriptions := updated;
  };

  public func unsubscribe(broker : Broker, id : Text) : Bool {
    var found = false;
    var updated : [Types.Subscription] = [];
    var i = 0;
    while (i < broker.subscriptions.size()) {
      let existing = broker.subscriptions[i];
      if (existing.id == id and not found) {
        found := true;
      } else {
        updated := Array.concat<Types.Subscription>(updated, [existing]);
      };
      i += 1;
    };
    if (found) {
      broker.subscriptions := updated;
    };
    found;
  };

  public func subscribersFor(broker : Broker, topic : Types.Topic) : [Types.Subscription] {
    var result : [Types.Subscription] = [];
    var i = 0;
    while (i < broker.subscriptions.size()) {
      let sub = broker.subscriptions[i];
      if (topicMatches(sub.topic, topic)) {
        result := Array.concat<Types.Subscription>(result, [sub]);
      };
      i += 1;
    };
    result;
  };

  public func count(broker : Broker) : Nat {
    broker.subscriptions.size();
  };
};
