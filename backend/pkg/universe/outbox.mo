import Principal "mo:core/Principal";
import Queue "mo:core/Queue";
import Time "mo:core/Time";
import Timer "mo:core/Timer";
import Types "./types";

module {
  public type FlushCallback = () -> async ();

  public type Outbox = {
    var queue : Queue.Queue<Types.Event>;
    var seqCounter : Nat;
    var heartbeatTimerId : ?Timer.TimerId;
    source : Principal;
  };

  public func create(source : Principal) : Outbox {
    {
      var queue = Queue.empty<Types.Event>();
      var seqCounter = 0;
      var heartbeatTimerId = null;
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
    Queue.pushBack(outbox.queue, event);
    event;
  };

  public func pending(outbox : Outbox) : [Types.Event] {
    Queue.toArray(outbox.queue);
  };

  public func acknowledge(outbox : Outbox, id : Types.EventId) : Bool {
    var found = false;
    let newQueue = Queue.empty<Types.Event>();
    for (item in Queue.values(outbox.queue)) {
      if (item.id == id and not found) {
        found := true;
      } else {
        Queue.pushBack(newQueue, item);
      };
    };
    if (found) {
      outbox.queue := newQueue;
    };
    found;
  };

  public func popNext(outbox : Outbox) : ?Types.Event {
    Queue.popFront(outbox.queue);
  };

  public func clear(outbox : Outbox) : () {
    Queue.clear(outbox.queue);
  };

  public func pendingCount(outbox : Outbox) : Nat {
    Queue.size(outbox.queue);
  };

  public func nextSequence(outbox : Outbox) : Nat {
    outbox.seqCounter + 1;
  };

  public func scheduleFlush<system>(
    outbox : Outbox,
    delay : Time.Duration,
    flushFn : FlushCallback,
  ) : Timer.TimerId {
    let timerId = Timer.setTimer<system>(delay, flushFn);
    outbox.heartbeatTimerId := ?timerId;
    timerId;
  };

  public func startHeartbeat<system>(
    outbox : Outbox,
    interval : Time.Duration,
    flushFn : FlushCallback,
  ) : Timer.TimerId {
    let timerId = Timer.recurringTimer<system>(interval, flushFn);
    outbox.heartbeatTimerId := ?timerId;
    timerId;
  };

  public func cancelTimer(outbox : Outbox) : () {
    switch (outbox.heartbeatTimerId) {
      case (?id) {
        Timer.cancelTimer(id);
        outbox.heartbeatTimerId := null;
      };
      case null ();
    };
  };

  public func activeTimerId(outbox : Outbox) : ?Timer.TimerId {
    outbox.heartbeatTimerId;
  };
};

