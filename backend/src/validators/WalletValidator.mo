import Principal "mo:core/Principal";
import PrincipalValidate "mo:pkg/validate/principal";
import NatValidate "mo:pkg/validate/nat";
import Text "mo:core/Text";

module {
  public func validateTransferId(id : Text) : ?Text {
    if (id.size() == 0) { ?"transferId is required" } else { null };
  };

  public func validateAmount(amount : Nat) : ?Text {
    NatValidate.positive(amount);
  };

  public func validateRecipient(principalText : Text) : ?Text {
    PrincipalValidate.validate(principalText);
  };

  public func parsePrincipal(text : Text) : ?Principal {
    if (PrincipalValidate.isValid(text)) { ?Principal.fromText(text) } else { null };
  };
};
