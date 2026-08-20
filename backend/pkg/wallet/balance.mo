import Icrc1 "mo:pkg/icrc1/icrc1";
import Account "account";

module {
  public func toIcrcAccount(account : Account.CustodialAccount) : Icrc1.Account {
    {
      owner = account.owner;
      subaccount = ?account.subaccount;
    };
  };
};
