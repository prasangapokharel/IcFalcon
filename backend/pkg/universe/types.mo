import Principal "mo:core/Principal";

module {
  public type Topic = Text;
  public type EventId = Text;

  public type Event = {
    id : EventId;
    topic : Topic;
    source : Principal;
    timestamp : Int;
    sequence : Nat;
    payload : Text;
    correlationId : ?Text;
  };

  public type Subscription = {
    id : Text;
    subscriber : Principal;
    topic : Topic;
    endpoint : Text;
    filter : ?Text;
  };

  public type DeliveryStatus = {
    #delivered;
    #failed : Text;
    #pending;
    #skipped;
  };

  public type Receipt = {
    eventId : EventId;
    subscriber : Principal;
    status : DeliveryStatus;
    timestamp : Int;
  };

  public type NodeInfo = {
    canister : Principal;
    moduleName : Text;
    topicsProduced : [Topic];
    topicsConsumed : [Topic];
  };
};
