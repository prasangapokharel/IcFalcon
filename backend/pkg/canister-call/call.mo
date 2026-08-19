import Principal "mo:core/Principal";

module {
  public type Target = { canister : Principal; method : Text };
  public func target(canister : Principal, method : Text) : Target { { canister; method } };
};
