import Array "mo:core/Array";
import Blob "mo:core/Blob";
import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Icrc1 "mo:pkg/icrc1/icrc1";
import SubaccountPkg "mo:pkg/subaccount/subaccount";

persistent actor class MockLedger() {
  var balances = Map.empty<Text, Nat>();
  var nextBlock : Nat = 1;
  var failNext = false;
  var owner = Principal.anonymous();
  let fee : Nat = 10_000;

  public func setOwner(canister : Principal) : async () {
    owner := canister;
  };

  func accountKey(account : Icrc1.Account) : Text {
    let sub = switch (account.subaccount) {
      case (null) SubaccountPkg.default;
      case (?value) value;
    };
    Principal.toText(account.owner) # ":" # SubaccountPkg.toHex(sub);
  };

  public func setBalance(account : Icrc1.Account, amount : Nat) : async () {
    Map.add(balances, Text.compare, accountKey(account), amount);
  };

  public func setFailNext(value : Bool) : async () {
    failNext := value;
  };

  public func reset() : async () {
    balances := Map.empty();
    nextBlock := 1;
    failNext := false;
  };

  public func icrc1_balance_of(account : Icrc1.Account) : async Nat {
    switch (Map.get(balances, Text.compare, accountKey(account))) {
      case (?amount) amount;
      case (null) 0;
    };
  };

  public func icrc1_fee() : async Nat { fee };

  public func icrc1_transfer(args : Icrc1.TransferArgs) : async Icrc1.TransferResult {
    if (failNext) {
      failNext := false;
      return #Err(#InsufficientFunds({ balance = 0 }));
    };

    let transferFee = switch (args.fee) { case (?value) value; case (null) fee };
    let fromAccount : Icrc1.Account = {
      owner;
      subaccount = args.from_subaccount;
    };
    let fromKey = accountKey(fromAccount);
    let fromBal = switch (Map.get(balances, Text.compare, fromKey)) {
      case (?value) value;
      case (null) 0;
    };

    if (args.amount + transferFee > fromBal) {
      return #Err(#InsufficientFunds({ balance = fromBal }));
    };

    let debitTotal = args.amount + transferFee;
    let newFromBal = Nat.sub(fromBal, debitTotal);
    Map.add(balances, Text.compare, fromKey, newFromBal);

    let toKey = accountKey(args.to);
    let toBal = switch (Map.get(balances, Text.compare, toKey)) {
      case (?value) value;
      case (null) 0;
    };
    Map.add(balances, Text.compare, toKey, toBal + args.amount);

    let block = nextBlock;
    nextBlock += 1;
    #Ok(block);
  };
};
