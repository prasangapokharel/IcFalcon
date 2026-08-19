module {
  public func runAll(steps : [() -> ()]) : () {
    for (step in steps.vals()) { step() };
  };
};
