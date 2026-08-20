import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";

import Account "account";
import Balance "balance";

module {
  public type CustodialAccount = Account.CustodialAccount;
  public type DepositInfo = Account.DepositInfo;

  public type Balances = Map.Map<Principal, Nat>;

  public let deriveAccount = Account.deriveAccount;
  public let depositInfo = Account.depositInfo;
  public let toIcrcAccount = Balance.toIcrcAccount;

  public func empty() : Balances { Map.empty() };

  public func credit(b : Balances, p : Principal, amount : Nat) : () {
    let current = switch (Map.get(b, Principal.compare, p)) { case (?n) n; case (null) 0 };
    Map.add(b, Principal.compare, p, current + amount);
  };

  public func debit(b : Balances, p : Principal, amount : Nat) : Bool {
    switch (Map.get(b, Principal.compare, p)) {
      case (?n) {
        if (n < amount) false else {
          Map.add(b, Principal.compare, p, n - amount);
          true;
        };
      };
      case (null) false;
    };
  };

  public func balance(b : Balances, p : Principal) : Nat {
    switch (Map.get(b, Principal.compare, p)) { case (?n) n; case (null) 0 };
  };
};
