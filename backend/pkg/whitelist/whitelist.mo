import Map "mo:core/Map";
import Principal "mo:core/Principal";

module {
  public type List = Map.Map<Principal, Bool>;
  public func empty() : List { Map.empty() };
  public func add(list : List, p : Principal) : () { Map.add(list, Principal.compare, p, true) };
  public func remove(list : List, p : Principal) : () { Map.remove(list, Principal.compare, p) };
  public func isAllowed(list : List, p : Principal) : Bool {
    switch (Map.get(list, Principal.compare, p)) { case (?_) true; case (null) false };
  };
};
