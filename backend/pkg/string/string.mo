import Text "mo:core/Text";
import Char "mo:core/Char";

module {
  public func truncate(value : Text, max : Nat) : Text {
    if (value.size() <= max) value else Text.substring(value, 0, max) # "...";
  };
  public func capitalize(value : Text) : Text {
    if (value.size() == 0) "" else {
      Text.toUppercase(Text.substring(value, 0, 1)) # Text.substring(value, 1, value.size());
    };
  };
};
