import Array "mo:core/Array";
import Blob "mo:core/Blob";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Hex "mo:pkg/base64/base64";
import SubaccountPkg "mo:pkg/subaccount/subaccount";

module {
  public type TokenRef = {
    ledgerId : Principal;
    symbol : Text;
    decimals : Nat8;
  };

  public type AccountIdentifier = [Nat8];
  public type Tokens = { e8s : Nat };

  public let transferFee : Nat = 10_000;
  public let icpTransferFee : Nat = transferFee;

  public func toE8s(icp : Nat) : Nat { icp * 100_000_000 };
  public func fromE8s(e8s : Nat) : Float { Int.toFloat(e8s) / 100_000_000.0 };

  public func accountId(owner : Principal, subaccount : ?SubaccountPkg.Subaccount) : AccountIdentifier {
    let subBlob = switch (subaccount) {
      case (?value) { value.toBlob() };
      case (null) { SubaccountPkg.default.toBlob() };
    };
    Blob.toArray(Principal.toLedgerAccount(owner, ?subBlob));
  };

  public func accountIdToHex(id : AccountIdentifier) : Text {
    Hex.toHex(id);
  };

  public func validateAmount(amount : Nat, fee : Nat, balance : Nat) : ?Text {
    if (amount + fee > balance) {
      ?"insufficient funds: amount + fee exceeds balance";
    } else {
      null;
    };
  };

  public func icpTokenRef(ledgerId : Principal) : TokenRef {
    { ledgerId; symbol = "ICP"; decimals = 8 };
  };
};
