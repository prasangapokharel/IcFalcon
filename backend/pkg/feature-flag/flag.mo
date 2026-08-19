import Map "mo:core/Map";
import Text "mo:core/Text";

module {
  public type Flags = Map.Map<Text, Bool>;
  public func empty() : Flags { Map.empty() };
  public func enable(f : Flags, name : Text) : () { Map.add(f, Text.compare, name, true) };
  public func disable(f : Flags, name : Text) : () { Map.add(f, Text.compare, name, false) };
  public func isOn(f : Flags, name : Text) : Bool {
    switch (Map.get(f, Text.compare, name)) { case (?v) v; case (null) false };
  };
};
