import Text "mo:core/Text";
import Map "mo:core/Map";

module {
  public type Store = Map.Map<Text, Bool>;
  public func empty() : Store { Map.empty() };
  public func register(store : Store, key : Text) : () { Map.add(store, Text.compare, key, true) };
  public func valid(store : Store, key : Text) : Bool {
    switch (Map.get(store, Text.compare, key)) { case (?_) true; case (null) false };
  };
  public func revoke(store : Store, key : Text) : () { Map.remove(store, Text.compare, key) };
};
