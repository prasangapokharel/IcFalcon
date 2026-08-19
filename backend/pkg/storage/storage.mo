import Map "mo:core/Map";
import Text "mo:core/Text";

module {
  public type TextStore<V> = Map.Map<Text, V>;
  public func textStore<V>() : TextStore<V> { Map.empty() };
  public func get<V>(s : TextStore<V>, k : Text) : ?V { Map.get(s, Text.compare, k) };
  public func put<V>(s : TextStore<V>, k : Text, v : V) : () { Map.add(s, Text.compare, k, v) };
  public func del<V>(s : TextStore<V>, k : Text) : () { Map.remove(s, Text.compare, k) };
  public func size<V>(s : TextStore<V>) : Nat { Map.size(s) };
};
