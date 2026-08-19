import Nat "mo:core/Nat";

module {
  public let billion : Nat = 1_000_000_000;
  public func toIcp(cycles : Nat, rate : Nat) : Nat { if (rate == 0) 0 else cycles / rate };
  public func daysRemaining(balance : Nat, dailyBurn : Nat) : Nat {
    if (dailyBurn == 0) 999 else balance / dailyBurn;
  };
  public func needsTopup(balance : Nat, threshold : Nat) : Bool { balance < threshold };
};
