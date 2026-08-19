module {
  public type Page<T> = {
    items : [T];
    total : Nat;
    offset : Nat;
    limit : Nat;
  };

  public func empty<T>(offset : Nat, limit : Nat) : Page<T> {
    { items = []; total = 0; offset; limit };
  };

  public func wrap<T>(items : [T], total : Nat, offset : Nat, limit : Nat) : Page<T> {
    { items; total; offset; limit };
  };
};
