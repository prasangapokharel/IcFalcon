import TextValidate "mo:pkg/validate/text";

module {
  public func validateName(name : Text) : ?Text {
    switch (TextValidate.notEmpty(name)) {
      case (?err) { ?err };
      case (null) { TextValidate.range(name, 2, 64) };
    };
  };
};
