import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public func isValid(text : Text) : Bool {
    switch (Principal.fromText(text)) { case (?_) true; case (null) false };
  };
  public func validate(text : Text) : ?Text {
    if (isValid(text)) null else ?"Invalid principal";
  };
  public func isAnonymous(p : Principal) : Bool { Principal.isAnonymous(p) };
};
