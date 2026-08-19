import Nat "mo:core/Nat";
import Float "mo:core/Float";

module {
  public type AccountIdentifier = [Nat8];
  public type Tokens = { e8s : Nat };
  public let transferFee : Nat = 10_000;
  public func toE8s(icp : Nat) : Nat { icp * 100_000_000 };
  public func fromE8s(e8s : Nat) : Float { Float.fromInt(e8s) / 100_000_000.0 };
};
