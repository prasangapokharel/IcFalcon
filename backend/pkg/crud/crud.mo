import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Map "mo:core/Map";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public type TextMap<V> = Map.Map<Text, V>;
  public type PrincipalMap<V> = Map.Map<Principal, V>;

  public func textEmpty<V>() : TextMap<V> {
    Map.empty();
  };

  public func principalEmpty<V>() : PrincipalMap<V> {
    Map.empty();
  };

  public func textGet<V>(store : TextMap<V>, key : Text) : ?V {
    Map.get(store, Text.compare, key);
  };

  public func textAdd<V>(store : TextMap<V>, key : Text, value : V) : () {
    Map.add(store, Text.compare, key, value);
  };

  public func textRemove<V>(store : TextMap<V>, key : Text) : () {
    Map.remove(store, Text.compare, key);
  };

  public func textValues<V>(store : TextMap<V>) : [V] {
    Iter.toArray(Map.values(store));
  };

  public func textSize<V>(store : TextMap<V>) : Nat {
    Map.size(store);
  };

  public func principalGet<V>(store : PrincipalMap<V>, key : Principal) : ?V {
    Map.get(store, Principal.compare, key);
  };

  public func principalAdd<V>(store : PrincipalMap<V>, key : Principal, value : V) : () {
    Map.add(store, Principal.compare, key, value);
  };

  public func principalValues<V>(store : PrincipalMap<V>) : [V] {
    Iter.toArray(Map.values(store));
  };

  public func principalSize<V>(store : PrincipalMap<V>) : Nat {
    Map.size(store);
  };

  public func page<V>(items : [V], offset : Nat, limit : Nat) : { items : [V]; total : Nat } {
    let total = items.size();
    let start = if (offset > total) { total } else { offset };
    let end = if (start + limit > total) { total } else { start + limit };
    let slice = Array.tabulate<V>(
      end - start,
      func(i : Nat) { items[start + i] },
    );
    { items = slice; total };
  };
};
