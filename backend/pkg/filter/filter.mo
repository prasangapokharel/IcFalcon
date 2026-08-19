import Array "mo:core/Array";

module {
  public func where<T>(items : [T], predicate : T -> Bool) : [T] {
    Array.filter(items, predicate);
  };
  public func first<T>(items : [T], predicate : T -> Bool) : ?T {
    Array.find(items, predicate);
  };
  public func count<T>(items : [T], predicate : T -> Bool) : Nat {
    Array.size(Array.filter(items, predicate));
  };
};
