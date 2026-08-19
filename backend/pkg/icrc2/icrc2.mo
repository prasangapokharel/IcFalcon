import Nat "mo:core/Nat";
import Principal "mo:core/Principal";

module {
  public type ApproveArgs = { from_subaccount : ?[Nat8]; spender : Principal; amount : Nat; expires_at : ?Nat64 };
  public type TransferFromArgs = { spender_subaccount : ?[Nat8]; from : Principal; to : Principal; amount : Nat; fee : ?Nat };
};
