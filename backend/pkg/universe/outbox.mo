import Array "mo:core/Array";
import Principal "mo:core/Principal";
import Types "./types";

module {
  public type Outbox = {
    var queue : [Types.Event];
    var seqCounter : Nat;
    source : Principal;
  };

  public func create(source : Principal) : Outbox {
    {
      var queue = [];
      var seqCounter = 0;
      source;
    };
  };

  public func enqueue(
    outbox : Outbox,
    id : Types.EventId,
    topic : Types.Topic,
    payload : Text,
    timestamp : Int,
    correlationId : ?Text,
  ) : Types.Event {
    outbox.seqCounter += 1;
    let event : Types.Event = {
      id;
      topic;
      source = outbox.source;
      timestamp;
      sequence = outbox.seqCounter;
      payload;
      correlationId;
    };
    outbox.queue := Array.concat<Types.Event>(outbox.queue, [event]);
    event;
  };

  public func pending(outbox : Outbox) : [Types.Event] {
    outbox.queue;
  };

  public func acknowledge(outbox : Outbox, id : Types.EventId) : Bool {
    var found = false;
    var remaining : [Types.Event] = [];
    var i = 0;
    while (i < outbox.queue.size()) {
      let item = outbox.queue[i];
      if (item.id == id and not found) {
        found := true;
      } else {
        remaining := Array.concat<Types.Event>(remaining, [item]);
      };
      i += 1;
    };
    if (found) {
      outbox.queue := remaining;
    };
    found;
  };

  public func clear(outbox : Outbox) : () {
    outbox.queue := [];
  };

  public func pendingCount(outbox : Outbox) : Nat {
    outbox.queue.size();
  };

  public func nextSequence(outbox : Outbox) : Nat {
    outbox.seqCounter + 1;
  };
};
