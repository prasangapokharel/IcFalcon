import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public func principalToText(p : Principal) : Text { Principal.toText(p) };
  public func textToPrincipal(t : Text) : ?Principal { Principal.fromText(t) };
};
