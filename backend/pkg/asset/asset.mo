import Text "mo:core/Text";
import Nat "mo:core/Nat";

module {
  public type Asset = { path : Text; contentType : Text; size : Nat };
  public func key(path : Text) : Text { if (Text.startsWith(path, #text "/")) path else "/" # path };
};
