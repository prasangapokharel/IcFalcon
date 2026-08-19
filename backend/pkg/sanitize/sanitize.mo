import Text "mo:core/Text";
import Char "mo:core/Char";

module {
  public func stripTags(input : Text) : Text {
    var out = "";
    var inTag = false;
    for (c in input.chars()) {
      if (c == '<') { inTag := true };
      if (not inTag) { out #= Char.toText(c) };
      if (c == '>') { inTag := false };
    };
    out;
  };
  public func trim(input : Text) : Text { Text.trim(input, #char ' ') };
};
