import Text "mo:core/Text";

module {
  public func isValid(email : Text) : Bool {
    email.size() > 3 and email.size() < 254
      and Text.contains(email, #text "@")
      and Text.contains(email, #text ".");
  };
  public func validate(email : Text) : ?Text {
    if (isValid(email)) null else ?"Invalid email";
  };
};
