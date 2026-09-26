import Array "mo:core/Array";
import Text "mo:core/Text";
import Types "./types";

module {
  public type Inbox = {
    var processed : [Types.EventId];
    maxCapacity : Nat;
  };

  public func create(maxCapacity : Nat) : Inbox {
    {
      var processed = [];
      maxCapacity;
    };
  };

  public func hasProcessed(inbox : Inbox, id : Types.EventId) : Bool {
    var i = 0;
    while (i < inbox.processed.size()) {
      if (inbox.processed[i] == id) {
        return true;
      };
      i += 1;
    };
    false;
  };

  public func record(inbox : Inbox, id : Types.EventId) : Bool {
    if (hasProcessed(inbox, id)) {
      return false;
    };

    var current = inbox.processed;
    if (current.size() >= inbox.maxCapacity and inbox.maxCapacity > 0) {
      let trimmed = Array.sliceToArray<Types.EventId>(current, 1, current.size());
      inbox.processed := Array.concat<Types.EventId>(trimmed, [id]);
    } else {
      inbox.processed := Array.concat<Types.EventId>(current, [id]);
    };
    true;
  };

  public func size(inbox : Inbox) : Nat {
    inbox.processed.size();
  };
};
