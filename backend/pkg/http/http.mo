module {
  public type Method = { #get; #post; #head };
  public type Header = { name : Text; value : Text };
  public type Request = { url : Text; method : Method; headers : [Header]; body : [Nat8]; maxResponseBytes : ?Nat64 };
  public func get(url : Text) : Request {
    { url; method = #get; headers = []; body = []; maxResponseBytes = ?2_000_000 };
  };
  public func post(url : Text, body : [Nat8]) : Request {
    { url; method = #post; headers = []; body; maxResponseBytes = ?2_000_000 };
  };
};
