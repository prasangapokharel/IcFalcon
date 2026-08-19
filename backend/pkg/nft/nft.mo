import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public type Token = { id : Nat; owner : Principal; metadata : Text };
  public type Collection = { name : Text; symbol : Text; total : Nat };
  public func isOwner(token : Token, p : Principal) : Bool { Principal.equal(token.owner, p) };
};
