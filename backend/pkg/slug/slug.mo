import Text "mo:core/Text";
import Array "mo:core/Array";
import Char "mo:core/Char";
import Iter "mo:core/Iter";

module {
  public func slugify(value : Text) : Text {
    let lower = Text.toLowercase(value);
    let chars = lower.chars();
    let filtered = Iter.filter<Char.Char>(
      chars,
      func(c : Char.Char) : Bool {
        Char.isAlphabetic(c) or Char.isDigit(c) or c == '-' or c == ' ';
      },
    );
    let parts = Iter.toArray(filtered);
    let withDashes = Array.map<Char.Char, Text>(
      parts,
      func(c : Char.Char) : Text {
        if (c == ' ') { "-" } else { Char.toText(c) };
      },
    );
    Text.join("", withDashes.vals());
  };

  public func isSlug(value : Text) : Bool {
    value.size() > 0 and slugify(value) == value;
  };
};
