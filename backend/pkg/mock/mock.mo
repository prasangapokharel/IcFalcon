import Nat "mo:core/Nat";
import Text "mo:core/Text";

module {
  public func lorem(index : Nat) : Text { "mock-" # Nat.toText(index) };
  public func email(index : Nat) : Text { "user" # Nat.toText(index) # "@example.com" };
  public func amount(index : Nat) : Nat { index * 1_000_000 };
};
