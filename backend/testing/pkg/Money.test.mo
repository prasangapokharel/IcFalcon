import TestPrincipals "../TestPrincipals";
import Ledger "mo:pkg/ledger/ledger";
import SubaccountPkg "mo:pkg/subaccount/subaccount";
import Test "mo:pkg/test/test";
import Transfer "mo:pkg/transfer/transfer";
import Wallet "mo:pkg/wallet/wallet";

module {
  public func run() : ?Text {
    let user = TestPrincipals.alice();
    let canister = TestPrincipals.canister();

    let sub1 = SubaccountPkg.fromPrincipal(user);
    let sub2 = SubaccountPkg.fromPrincipal(user);
    switch (Test.assertTrue(SubaccountPkg.equal(sub1, sub2))) { case (?e) return ?e; case (null) {} };

    let token = Ledger.icpTokenRef(canister);
    let account = Wallet.deriveAccount(canister, user, token);
    let deposit = Wallet.depositInfo(account);
    switch (Test.assertTrue(deposit.accountIdHex.size() == 64)) { case (?e) return ?e; case (null) {} };

    let icrc = Wallet.toIcrcAccount(account);
    switch (Test.assertTrue(icrc.owner == canister)) { case (?e) return ?e; case (null) {} };

    let req : Transfer.TransferRequest = {
      transferId = "tx-1";
      from = account;
      to = { owner = canister; subaccount = ?SubaccountPkg.fromPrincipal(user) };
      amount = 1_000;
      memo = null;
    };
    switch (Transfer.validateRequest(req, 1_000, 10_000)) {
      case (null) return ?"expected fee reserve validation error";
      case (?_) {};
    };
    switch (Transfer.validateRequest(req, 1_010_000, 10_000)) {
      case (?_) return ?"expected valid transfer request";
      case (null) {};
    };

    null;
  };
};
