module {
  public func assertEqual<T>(actual : T, expected : T, eq : (T, T) -> Bool) : ?Text {
    if (eq(actual, expected)) null else ?"Assertion failed";
  };
  public func assertTrue(value : Bool) : ?Text {
    if (value) null else ?"Expected true";
  };
};
