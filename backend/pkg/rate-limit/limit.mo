import Map "mo:core/Map";
import Principal "mo:core/Principal";
import Time "mo:core/Time";

module {
  public type Bucket = { count : Nat; resetAt : Int };
  public type Store = Map.Map<Principal, Bucket>;
  public func empty() : Store { Map.empty() };
  public func allow(store : Store, p : Principal, max : Nat, window : Int) : Bool {
    let now = Time.now();
    switch (Map.get(store, Principal.compare, p)) {
      case (?b) {
        if (now > b.resetAt) {
          Map.add(store, Principal.compare, p, { count = 1; resetAt = now + window });
          true;
        } else if (b.count >= max) { false }
        else {
          Map.add(store, Principal.compare, p, { count = b.count + 1; resetAt = b.resetAt });
          true;
        };
      };
      case (null) {
        Map.add(store, Principal.compare, p, { count = 1; resetAt = now + window });
        true;
      };
    };
  };
};
