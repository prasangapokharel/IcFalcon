import Char "mo:core/Char";
import Iter "mo:core/Iter";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  func hasDash(text : Text) : Bool {
    Iter.any(text.chars(), func(c : Char) : Bool { c == '-' });
  };

  public func isValid(text : Text) : Bool {
    text.size() >= 5 and hasDash(text);
  };

  public func validate(text : Text) : ?Text {
    if (isValid(text)) null else ?"Invalid principal";
  };

  public func isAnonymous(p : Principal) : Bool { Principal.isAnonymous(p) };
};
