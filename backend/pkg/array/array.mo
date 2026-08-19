import Array "mo:core/Array";

module {
  public func chunk<T>(items : [T], size : Nat) : [[T]] {
    if (size == 0) return [];
    var out : [[T]] = [];
    var i = 0;
    while (i < items.size()) {
      let end = if (i + size > items.size()) items.size() else i + size;
      out := Array.append(out, [Array.tabulate(end - i, func(j : Nat) { items[i + j] })]);
      i += size;
    };
    out;
  };
  public func unique<T>(items : [T], eq : (T, T) -> Bool) : [T] {
    var out : [T] = [];
    for (item in items.vals()) {
      if (Array.find(out, func(x : T) : Bool { eq(x, item) }) == null) {
        out := Array.append(out, [item]);
      };
    };
    out;
  };
};
