import Text "mo:core/Text";

module {
  public func string(value : Text) : Text { "\"" # escape(value) # "\"" };
  public func number(n : Nat) : Text { Nat.toText(n) };
  public func bool(b : Bool) : Text { if (b) "true" else "false" };
  public func object(fields : [(Text, Text)]) : Text {
    "{" # joinFields(fields) # "}";
  };
  func escape(t : Text) : Text { t };
  func joinFields(fields : [(Text, Text)]) : Text {
    var out = "";
    var first = true;
    for ((k, v) in fields.vals()) {
      if (not first) { out #= "," };
      out #= "\"" # k # "\":" # v;
      first := false;
    };
    out;
  };
};
