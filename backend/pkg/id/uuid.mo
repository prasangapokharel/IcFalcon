import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public func fromPrincipal(prefix : Text, principal : Principal) : Text {
    prefix # "-" # Principal.toText(principal);
  };
};
