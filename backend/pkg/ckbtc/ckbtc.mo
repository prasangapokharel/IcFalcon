import Ledger "mo:pkg/ledger/ledger";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public type CkBtcToken = Ledger.TokenRef;

  public let satoshiPerBtc : Nat = 100_000_000;

  public func tokenRef(ledgerId : Principal) : Ledger.TokenRef {
    { ledgerId; symbol = "ckBTC"; decimals = 8 };
  };

  public func mainnetTokenRef(ledgerId : Principal) : Ledger.TokenRef {
    tokenRef(ledgerId);
  };

  public func toSatoshi(btc : Nat) : Nat {
    btc * satoshiPerBtc;
  };

  public func fromSatoshi(sats : Nat) : Nat {
    sats / satoshiPerBtc;
  };

  public func satoshiToTokenAmount(sats : Nat) : Nat {
    sats;
  };

  public func validateBtcAddress(address : Text) : ?Text {
    validateAddress(address);
  };

  public func validateAddress(address : Text) : ?Text {
    if (address.size() < 20) { ?"invalid ckBTC address" } else { null };
  };

  public func formatSats(sats : Nat) : Text {
    Nat.toText(sats) # " sats";
  };
};
