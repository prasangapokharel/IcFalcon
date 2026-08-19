module {
  public type Role = { #owner; #admin; #member; #guest };

  public type Action = { #read; #write; #delete; #manage };

  public func can(role : Role, action : Action) : Bool {
    switch (role, action) {
      case (#owner, _) { true };
      case (#admin, #manage) { true };
      case (#admin, #delete) { true };
      case (#admin, #write) { true };
      case (#admin, #read) { true };
      case (#member, #write) { true };
      case (#member, #read) { true };
      case (#guest, #read) { true };
      case (_, _) { false };
    };
  };

  public func require(role : Role, action : Action) : ?Text {
    if (can(role, action)) { null } else { ?"Forbidden" };
  };

  public func fromText(role : Text) : Role {
    switch (role) {
      case ("owner") { #owner };
      case ("admin") { #admin };
      case ("member") { #member };
      case (_) { #guest };
    };
  };

  public func toText(role : Role) : Text {
    switch (role) {
      case (#owner) { "owner" };
      case (#admin) { "admin" };
      case (#member) { "member" };
      case (#guest) { "guest" };
    };
  };
};
