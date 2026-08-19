import Nat "mo:core/Nat";
import Principal "mo:core/Principal";

module {
  public type Account = { owner : Principal; subaccount : ?[Nat8] };
  public type TransferArgs = { from_subaccount : ?[Nat8]; to : Account; amount : Nat; fee : ?Nat; memo : ?[Nat8]; created_at_time : ?Nat64 };
  public func defaultFee() : Nat { 10_000 };
};
