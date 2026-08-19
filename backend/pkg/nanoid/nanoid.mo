import Text "mo:core/Text";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";

module {
  public func fromSeed(prefix : Text, seed : Nat) : Text {
    prefix # "-" # Nat.toText(seed);
  };
  public func fromPrincipal(prefix : Text, p : Principal) : Text {
    prefix # "-" # Principal.toText(p);
  };
};
