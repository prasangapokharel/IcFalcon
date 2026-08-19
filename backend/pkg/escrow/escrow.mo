import Nat "mo:core/Nat";
import Principal "mo:core/Principal";

module {
  public type Status = { #held; #released; #refunded };
  public type Escrow = { id : Nat; payer : Principal; payee : Principal; amount : Nat; var status : Status };
  public func release(e : Escrow) : Escrow { { e with status = #released } };
  public func refund(e : Escrow) : Escrow { { e with status = #refunded } };
  public func isHeld(e : Escrow) : Bool { e.status == #held };
};
