module {
  public func notEmpty(value : Text) : ?Text {
    if (value.size() == 0) { ?"Required" } else { null };
  };

  public func minLength(value : Text, min : Nat) : ?Text {
    if (value.size() < min) { ?"Too short" } else { null };
  };

  public func maxLength(value : Text, max : Nat) : ?Text {
    if (value.size() > max) { ?"Too long" } else { null };
  };

  public func range(value : Text, min : Nat, max : Nat) : ?Text {
    switch (minLength(value, min)) {
      case (?err) { ?err };
      case (null) { maxLength(value, max) };
    };
  };
};
