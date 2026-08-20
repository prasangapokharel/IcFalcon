import Array "mo:core/Array";
import Blob "mo:core/Blob";
import Char "mo:core/Char";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public type Subaccount = [Nat8];

  public let default : Subaccount = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ];

  public func fromPrincipal(p : Principal) : Subaccount {
    pad32(Blob.toArray(Principal.toBlob(p)));
  };

  public func fromNat(n : Nat) : Subaccount {
    Array.tabulate<Nat8>(32, func(i) { byteAt(n, i) });
  };

  public func toHex(s : Subaccount) : Text {
    let chars = "0123456789abcdef";
    var out = "";
    for (b in s.vals()) {
      let byte = Nat8.toNat(b);
      out #= charAt(chars, byte / 16) # charAt(chars, byte % 16);
    };
    out;
  };

  public func equal(a : Subaccount, b : Subaccount) : Bool {
    if (a.size() != b.size()) return false;
    for (i in a.keys()) {
      if (a[i] != b[i]) return false;
    };
    true;
  };

  public func compare(a : Subaccount, b : Subaccount) : { #less; #equal; #greater } {
    if (equal(a, b)) #equal
    else if (lessBytes(a, b)) #less
    else #greater;
  };

  func pad32(bytes : [Nat8]) : Subaccount {
    Array.tabulate<Nat8>(32, func(i) {
      if (i < bytes.size()) bytes[i] else 0;
    });
  };

  func byteAt(n : Nat, index : Nat) : Nat8 {
    let position = 31 - index;
    Nat8.fromIntWrap(((n / pow256(position)) % 256) : Int);
  };

  func pow256(exp : Nat) : Nat {
    var result = 1;
    var i = 0;
    while (i < exp) {
      result *= 256;
      i += 1;
    };
    result;
  };

  func lessBytes(a : [Nat8], b : [Nat8]) : Bool {
    let len = if (a.size() < b.size()) a.size() else b.size();
    var i = 0;
    while (i < len) {
      if (a[i] < b[i]) return true;
      if (a[i] > b[i]) return false;
      i += 1;
    };
    a.size() < b.size();
  };

  func charAt(t : Text, index : Nat) : Text {
    var i = 0;
    for (c in t.chars()) {
      if (i == index) return Char.toText(c);
      i += 1;
    };
    "";
  };
};
