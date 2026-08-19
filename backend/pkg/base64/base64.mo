import Nat8 "mo:core/Nat8";
import Nat "mo:core/Nat";
import Char "mo:core/Char";
import Text "mo:core/Text";

module {
  public func toHex(bytes : [Nat8]) : Text {
    let chars = "0123456789abcdef";
    var out = "";
    for (b in bytes.vals()) {
      let n = Nat8.toNat(b);
      out #= charAt(chars, n / 16) # charAt(chars, n % 16);
    };
    out;
  };
  func charAt(t : Text, index : Nat) : Text {
    var i = 0;
    for (c in t.chars()) { if (i == index) return Char.toText(c); i += 1 };
    "";
  };
};
