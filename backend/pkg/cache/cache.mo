import Time "mo:core/Time";
import Map "mo:core/Map";
import Text "mo:core/Text";

module {
  public type Entry<V> = { value : V; expiresAt : Int };
  public type Cache<V> = Map.Map<Text, Entry<V>>;
  public func empty<V>() : Cache<V> { Map.empty() };
  public func get<V>(c : Cache<V>, key : Text) : ?V {
    switch (Map.get(c, Text.compare, key)) {
      case (null) null;
      case (?e) { if (Time.now() > e.expiresAt) null else ?e.value };
    };
  };
  public func set<V>(c : Cache<V>, key : Text, value : V, ttl : Int) : () {
    Map.add(c, Text.compare, key, { value; expiresAt = Time.now() + ttl });
  };
};
