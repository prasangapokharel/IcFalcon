import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import SubaccountPkg "mo:pkg/subaccount/subaccount";

module {
  public type ApproveArgs = {
    from_subaccount : ?SubaccountPkg.Subaccount;
    spender : Account;
    amount : Nat;
    expires_at : ?Nat64;
    fee : ?Nat;
    memo : ?[Nat8];
    created_at_time : ?Nat64;
  };

  public type TransferFromArgs = {
    spender_subaccount : ?SubaccountPkg.Subaccount;
    from : Account;
    to : Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?[Nat8];
    created_at_time : ?Nat64;
  };

  public type Account = { owner : Principal; subaccount : ?SubaccountPkg.Subaccount };

  public type ApproveError = {
    #BadFee : { expected_fee : Nat };
    #InsufficientFunds : { balance : Nat };
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #Duplicate : { duplicate_of : Nat };
    #TemporarilyUnavailable;
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferFromError = {
    #BadFee : { expected_fee : Nat };
    #InsufficientFunds : { balance : Nat };
    #InsufficientAllowance : { allowance : Nat };
    #TooOld;
    #CreatedInFuture : { ledger_time : Nat64 };
    #Duplicate : { duplicate_of : Nat };
    #TemporarilyUnavailable;
    #GenericError : { error_code : Nat; message : Text };
  };

  public func buildApprove(
    fromSub : ?SubaccountPkg.Subaccount,
    spender : Account,
    amount : Nat,
    expiresAt : ?Nat64,
    fee : ?Nat,
  ) : ApproveArgs {
    {
      from_subaccount = fromSub;
      spender;
      amount;
      expires_at = expiresAt;
      fee;
      memo = null;
      created_at_time = null;
    };
  };

  public func buildTransferFrom(
    spenderSub : ?SubaccountPkg.Subaccount,
    from : Account,
    to : Account,
    amount : Nat,
    fee : ?Nat,
  ) : TransferFromArgs {
    {
      spender_subaccount = spenderSub;
      from;
      to;
      amount;
      fee;
      memo = null;
      created_at_time = null;
    };
  };

  public func transferFromErrorText(e : TransferFromError) : Text {
    switch (e) {
      case (#BadFee({ expected_fee })) { "bad fee: expected " # Nat.toText(expected_fee) };
      case (#InsufficientFunds({ balance })) { "insufficient funds: balance " # Nat.toText(balance) };
      case (#InsufficientAllowance({ allowance })) { "insufficient allowance: " # Nat.toText(allowance) };
      case (#TooOld) { "transfer too old" };
      case (#CreatedInFuture({ ledger_time })) { "created in future: " # Nat64.toText(ledger_time) };
      case (#Duplicate({ duplicate_of })) { "duplicate of block " # Nat.toText(duplicate_of) };
      case (#TemporarilyUnavailable) { "ledger temporarily unavailable" };
      case (#GenericError({ error_code; message })) { "error " # Nat.toText(error_code) # ": " # message };
    };
  };
};
