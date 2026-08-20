import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Ledger "mo:pkg/ledger/ledger";
import SubaccountPkg "mo:pkg/subaccount/subaccount";

module {
  public type Account = { owner : Principal; subaccount : ?SubaccountPkg.Subaccount };

  public type TransferArgs = {
    from_subaccount : ?SubaccountPkg.Subaccount;
    to : Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?[Nat8];
    created_at_time : ?Nat64;
  };

  public type TransferError = {
    #BadFee : { expected_fee : Nat };
    #InsufficientFunds : { balance : Nat };
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #Duplicate : { duplicate_of : Nat };
    #TemporarilyUnavailable;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferResult = { #Ok : Nat; #Err : TransferError };

  public type LedgerActor = actor {
    icrc1_transfer : (TransferArgs) -> async TransferResult;
    icrc1_balance_of : (Account) -> async Nat;
    icrc1_fee : () -> async Nat;
  };

  public func defaultFee() : Nat { Ledger.icpTransferFee };

  public func buildTransfer(
    fromSub : ?SubaccountPkg.Subaccount,
    to : Account,
    amount : Nat,
    fee : ?Nat,
  ) : TransferArgs {
    {
      from_subaccount = fromSub;
      to;
      amount;
      fee;
      memo = null;
      created_at_time = null;
    };
  };

  public func accountId(account : Account) : Ledger.AccountIdentifier {
    Ledger.accountId(account.owner, account.subaccount);
  };

  public func errorText(e : TransferError) : Text {
    switch (e) {
      case (#BadFee({ expected_fee })) { "bad fee: expected " # Nat.toText(expected_fee) };
      case (#InsufficientFunds({ balance })) { "insufficient funds: balance " # Nat.toText(balance) };
      case (#TooOld) { "transfer too old" };
      case (#CreatedInFuture({ ledger_time })) { "created in future: " # Nat64.toText(ledger_time) };
      case (#Duplicate({ duplicate_of })) { "duplicate of block " # Nat.toText(duplicate_of) };
      case (#TemporarilyUnavailable) { "ledger temporarily unavailable" };
      case (#GenericError({ error_code; message })) { "error " # Nat.toText(error_code) # ": " # message };
    };
  };
};
