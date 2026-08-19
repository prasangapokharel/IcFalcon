module {
  public type Result<T> = { #ok : T; #err : Text };
  public func withRetry<T>(attempts : Nat, run : () -> async Result<T>) : async Result<T> {
    var left = attempts;
    var last = "";
    while (left > 0) {
      switch (await run()) {
        case (#ok(v)) return #ok(v);
        case (#err(e)) { last := e; left -= 1 };
      };
    };
    #err(last);
  };
};
