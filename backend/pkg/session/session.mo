import Map "mo:core/Map";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Principal "mo:core/Principal";

module {
  public type Session = { principal : Principal; expiresAt : Int };
  public type Store = Map.Map<Text, Session>;
  public func empty() : Store { Map.empty() };
  public func create(store : Store, token : Text, principal : Principal, ttl : Int) : () {
    Map.add(store, Text.compare, token, { principal; expiresAt = Time.now() + ttl });
  };
  public func resolve(store : Store, token : Text) : ?Principal {
    switch (Map.get(store, Text.compare, token)) {
      case (?s) { if (Time.now() > s.expiresAt) null else ?s.principal };
      case (null) null;
    };
  };
};
