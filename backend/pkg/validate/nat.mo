module {
  public func positive(value : Nat) : ?Text {
    if (value == 0) { ?"Must be positive" } else { null };
  };

  public func maxValue(value : Nat, max : Nat) : ?Text {
    if (value > max) { ?"Too large" } else { null };
  };
};
