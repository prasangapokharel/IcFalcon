import Text "mo:core/Text";

module {
  public func isValid(url : Text) : Bool {
    Text.startsWith(url, #text "http://") or Text.startsWith(url, #text "https://");
  };
  public func validate(url : Text) : ?Text {
    if (isValid(url)) null else ?"Invalid URL";
  };
};
