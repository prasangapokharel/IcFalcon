import Principal "mo:core/Principal";
import Array "mo:core/Array";

module {
  public type Proposal = { id : Nat; approvals : [Principal]; required : Nat };
  public func approve(p : Proposal, caller : Principal) : Proposal {
    if (Array.find(p.approvals, func(x : Principal) : Bool { Principal.equal(x, caller) }) != null) { p }
    else { { p with approvals = Array.append(p.approvals, [caller]) } };
  };
  public func isApproved(p : Proposal) : Bool { p.approvals.size() >= p.required };
};
