import Principal "mo:core/Principal";

module {
  public let version = "0.1.0";
  public let appName = "IcFalcon";

  public func icpLedgerId() : Principal {
    Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai");
  };
};
