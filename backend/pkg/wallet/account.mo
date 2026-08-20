import Icrc1 "mo:pkg/icrc1/icrc1";
import Ledger "mo:pkg/ledger/ledger";
import Principal "mo:core/Principal";
import SubaccountPkg "mo:pkg/subaccount/subaccount";
import Text "mo:core/Text";

module {
  public type CustodialAccount = {
    user : Principal;
    owner : Principal;
    subaccount : SubaccountPkg.Subaccount;
    token : Ledger.TokenRef;
  };

  public type DepositInfo = {
    icrcAccount : Icrc1.Account;
    accountIdHex : Text;
    qrPayload : Text;
  };

  public func deriveAccount(
    canister : Principal,
    user : Principal,
    token : Ledger.TokenRef,
  ) : CustodialAccount {
    {
      user;
      owner = canister;
      subaccount = SubaccountPkg.fromPrincipal(user);
      token;
    };
  };

  public func depositInfo(account : CustodialAccount) : DepositInfo {
    let icrcAccount = {
      owner = account.owner;
      subaccount = ?account.subaccount;
    };
    let hex = Ledger.accountIdToHex(Ledger.accountId(account.owner, ?account.subaccount));
    {
      icrcAccount;
      accountIdHex = hex;
      qrPayload = hex;
    };
  };
};
