import Principal "mo:core/Principal";
import Nat "mo:core/Nat";

module {
  public type Vote = { #yes; #no; #abstain };
  public type Proposal = { id : Nat; title : Text; var yes : Nat; var no : Nat; deadline : Int };
  public func cast(proposal : Proposal, vote : Vote) : Proposal {
    switch (vote) {
      case (#yes) { { proposal with yes = proposal.yes + 1 } };
      case (#no) { { proposal with no = proposal.no + 1 } };
      case (#abstain) proposal;
    };
  };
  public func passed(p : Proposal, quorum : Nat) : Bool { p.yes > p.no and p.yes >= quorum };
};
