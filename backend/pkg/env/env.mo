import Text "mo:core/Text";
import Map "mo:core/Map";

module {
  public type Config = Map.Map<Text, Text>;
  public func empty() : Config { Map.empty() };
  public func set(c : Config, key : Text, value : Text) : () { Map.add(c, Text.compare, key, value) };
  public func get(c : Config, key : Text) : ?Text { Map.get(c, Text.compare, key) };
  public func require(c : Config, key : Text) : ?Text {
    switch (get(c, key)) { case (null) ?("Missing config: " # key); case (?_) null };
  };
};
