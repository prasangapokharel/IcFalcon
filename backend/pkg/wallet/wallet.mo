import Nat "mo:core/Nat";
import Map "mo:core/Map";
import Principal "mo:core/Principal";

module {
  public type Balances = Map.Map<Principal, Nat>;
  public func empty() : Balances { Map.empty() };
  public func credit(b : Balances, p : Principal, amount : Nat) : () {
    let current = switch (Map.get(b, Principal.compare, p)) { case (?n) n; case (null) 0 };
    Map.add(b, Principal.compare, p, current + amount);
  };
  public func debit(b : Balances, p : Principal, amount : Nat) : Bool {
    switch (Map.get(b, Principal.compare, p)) {
      case (?n) { if (n < amount) false else { Map.add(b, Principal.compare, p, n - amount); true } };
      case (null) false;
    };
  };
  public func balance(b : Balances, p : Principal) : Nat {
    switch (Map.get(b, Principal.compare, p)) { case (?n) n; case (null) 0 };
  };
};
