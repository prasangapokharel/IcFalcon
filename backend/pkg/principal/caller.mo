import Principal "mo:core/Principal";

module {
  public func isAnonymous(principal : Principal) : Bool {
    Principal.isAnonymous(principal);
  };

  public func requireAuth(principal : Principal) : ?Text {
    if (Principal.isAnonymous(principal)) {
      ?"Unauthorized";
    } else {
      null;
    };
  };

  public func equals(left : Principal, right : Principal) : Bool {
    Principal.equal(left, right);
  };

  public func toText(principal : Principal) : Text {
    Principal.toText(principal);
  };
};
