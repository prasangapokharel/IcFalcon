import Principal "mo:core/Principal";

module {
  public func alice() : Principal { Principal.fromText("aaaaa-aa") };
  public func bob() : Principal { Principal.fromText("rdmx6-jaaaa-aaaaa-aaadq-cai") };
  public func canister() : Principal { Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai") };
  public func ledger() : Principal { Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai") };
  public func anonymous() : Principal { Principal.fromText("2vxsx-fae") };
};
