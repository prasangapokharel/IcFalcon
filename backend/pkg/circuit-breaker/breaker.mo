module {
  public type State = { #closed; #open; #halfOpen };
  public type Breaker = { var state : State; var failures : Nat; threshold : Nat };
  public func create(threshold : Nat) : Breaker { { var state = #closed; var failures = 0; threshold } };
  public func allow(b : Breaker) : Bool {
    switch (b.state) { case (#open) false; case (_) true };
  };
  public func recordSuccess(b : Breaker) : () { b.failures := 0; b.state := #closed };
  public func recordFailure(b : Breaker) : () {
    b.failures += 1;
    if (b.failures >= b.threshold) { b.state := #open };
  };
};
