import Nat "mo:core/Nat";
import Ledger "mo:pkg/ledger/ledger";
import TestPrincipals "../TestPrincipals";
import SubaccountPkg "mo:pkg/subaccount/subaccount";
import Test "mo:pkg/test/test";
import Transaction "mo:pkg/transaction/transaction";
import Transfer "mo:pkg/transfer/transfer";
import Wallet "mo:pkg/wallet/wallet";

module {
  public func run() : ?Text {
    let user = TestPrincipals.alice();
    let recipient = TestPrincipals.bob();
    let canister = TestPrincipals.canister();
    let token = Ledger.icpTokenRef(canister);
    let fee : Nat = 10_000;

    let from = Wallet.deriveAccount(canister, user, token);
    let to = Wallet.toIcrcAccount(Wallet.deriveAccount(canister, recipient, token));

    let req : Transfer.TransferRequest = {
      transferId = "tx-fee";
      from;
      to;
      amount = 100_000;
      memo = null;
    };

    switch (Transfer.validateRequest(req, 100_000, fee)) {
      case (null) return ?"must reject when balance equals amount without fee room";
      case (?_) {};
    };

    switch (Transfer.validateRequest(req, 100_000 + fee, fee)) {
      case (?_) return ?"must accept when balance covers amount + fee";
      case (null) {};
    };

    switch (Transfer.validateRequest(req, 100_000 + fee - 1, fee)) {
      case (null) return ?"must reject when balance is one e8s short";
      case (?_) {};
    };

    let fail = Transfer.mapResult(#Err(#InsufficientFunds({ balance = 0 })));
    switch (fail) {
      case (#ok _) return ?"failed ledger result must map to err";
      case (#err _) {};
    };
    let rowsOnFail = Transfer.recordsForTransfer(req, fail, fee, ?recipient, 0);
    switch (Test.assertTrue(rowsOnFail.size() == 0)) {
      case (?e) return ?e;
      case (null) {};
    };

    let ok = Transfer.mapResult(#Ok(42));
    let externalRows = Transfer.recordsForTransfer(req, ok, fee, null, 0);
    switch (Test.assertTrue(externalRows.size() == 1)) {
      case (?e) return ?e;
      case (null) {};
    };

    let internalRows = Transfer.recordsForTransfer(req, ok, fee, ?recipient, 0);
    switch (Test.assertTrue(internalRows.size() == 2)) {
      case (?e) return ?e;
      case (null) {};
    };

    switch (internalRows[0].kind) {
      case (#transferOut) {};
      case (_) return ?"sender row must be transferOut";
    };
    switch (internalRows[1].kind) {
      case (#transferIn) {};
      case (_) return ?"recipient row must be transferIn";
    };

    switch (Test.assertTrue(internalRows[0].fee == fee)) {
      case (?e) return ?e;
      case (null) {};
    };

    null;
  };
};
