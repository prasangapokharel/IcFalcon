module {
  public type Step = { version : Nat; run : () -> () };
  public func runAll(steps : [Step], from : Nat, to_ : Nat) : () {
    for (step in steps.vals()) {
      if (step.version > from and step.version <= to_) { step.run() };
    };
  };
};
