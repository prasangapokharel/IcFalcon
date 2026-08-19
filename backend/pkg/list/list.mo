import List "mo:core/List";

module {
  public func fromArray<T>(items : [T]) : List.List<T> {
    var acc = List.empty<T>();
    for (item in items.vals()) { acc := List.push(item, acc) };
    List.reverse(acc);
  };
  public func toArray<T>(items : List.List<T>) : [T] {
    List.toArray(items);
  };
  public func size<T>(items : List.List<T>) : Nat { List.size(items) };
};
