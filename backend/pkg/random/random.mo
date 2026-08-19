import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";

module {
  public func fromBlob(seed : [Nat8]) : Nat {
    var acc : Nat = 0;
    for (b in seed.vals()) { acc := acc * 256 + Nat8.toNat(b) };
    acc;
  };
  public func pick(seed : Nat, max : Nat) : Nat { if (max == 0) 0 else seed % max };
};
