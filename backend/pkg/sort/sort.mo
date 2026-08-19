import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Order "mo:core/Order";

module {
  public func byNat<T>(items : [T], project : T -> Nat) : [T] {
    Array.sort(items, func(a : T, b : T) : Order.Order { Nat.compare(project(a), project(b)) });
  };
  public func byText<T>(items : [T], project : T -> Text) : [T] {
    Array.sort(items, func(a : T, b : T) : Order.Order { Text.compare(project(a), project(b)) });
  };
};
