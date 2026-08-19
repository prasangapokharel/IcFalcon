import TextValidate "mo:pkg/validate/text";

module {
  public func validateUsername(username : Text) : ?Text {
    switch (TextValidate.notEmpty(username)) {
      case (?err) { ?err };
      case (null) { TextValidate.range(username, 2, 32) };
    };
  };

  public func validateName(name : Text) : ?Text {
    switch (TextValidate.notEmpty(name)) {
      case (?err) { ?err };
      case (null) { TextValidate.range(name, 2, 64) };
    };
  };
};
