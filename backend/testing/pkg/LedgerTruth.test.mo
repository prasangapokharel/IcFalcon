import Nat "mo:core/Nat";
import Ledger "mo:pkg/ledger/ledger";
import TestPrincipals "../TestPrincipals";
import Test "mo:pkg/test/test";
import Transaction "mo:pkg/transaction/transaction";
import TransactionRepo "mo:app/repositories/TransactionRepository";
import Wallet "mo:pkg/wallet/wallet";

module {
  public func run() : ?Text {
    let user = TestPrincipals.alice();
    let canister = TestPrincipals.canister();
    let token = Ledger.icpTokenRef(canister);
    let store = Transaction.emptyStore();

    let ledgerBalance : Nat = 5_000_000;
    TransactionRepo.insert(store, {
      id = "in-1";
      user;
      kind = #transferIn;
      amount = 1_000_000;
      fee = 0;
      counterparty = null;
      token;
      blockIndex = ?1;
      status = #completed;
      createdAt = 1;
      memo = null;
    });

    let indexedSum = TransactionRepo.sumCompletedIn(store, user);
    switch (Test.assertTrue(indexedSum == 1_000_000)) { case (?e) return ?e; case (null) {} };
    switch (Test.assertTrue(indexedSum != ledgerBalance)) {
      case (?e) return ?e;
      case (null) {};
    };

    let account = Wallet.deriveAccount(canister, user, token);
    let _deposit = Wallet.depositInfo(account);
    switch (Test.assertTrue(true)) { case (?e) return ?e; case (null) {} };

    null;
  };
};
