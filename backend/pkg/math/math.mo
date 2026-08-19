import Nat "mo:core/Nat";
import Int "mo:core/Int";

module {
  public func percent(part : Nat, total : Nat) : Nat {
    if (total == 0) 0 else (part * 100) / total;
  };
  public func clamp(value : Nat, min : Nat, max : Nat) : Nat {
    if (value < min) min else if (value > max) max else value;
  };
  public func safeDiv(a : Nat, b : Nat) : Nat { if (b == 0) 0 else a / b };
};
