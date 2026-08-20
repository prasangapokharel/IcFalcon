import Ledger "mo:pkg/ledger/ledger";
import TestPrincipals "../TestPrincipals";
import Test "mo:pkg/test/test";
import Transaction "mo:pkg/transaction/transaction";
import TransactionRepo "mo:app/repositories/TransactionRepository";

module {
  func sampleTx(
    id : Text,
    user : Principal,
    createdAt : Int,
    amount : Nat,
  ) : Transaction.TxRecord {
    {
      id;
      user;
      kind = #transferIn;
      amount;
      fee = 0;
      counterparty = null;
      token = Ledger.icpTokenRef(TestPrincipals.canister());
      blockIndex = ?1;
      status = #completed;
      createdAt;
      memo = null;
    };
  };

  public func run() : ?Text {
    let user = TestPrincipals.alice();
    let store = Transaction.emptyStore();

    TransactionRepo.insert(store, sampleTx("tx-3", user, 30, 300));
    TransactionRepo.insert(store, sampleTx("tx-1", user, 10, 100));
    TransactionRepo.insert(store, sampleTx("tx-2", user, 20, 200));

    let page1 = TransactionRepo.listPage(store, user, 0, 2);
    switch (Test.assertTrue(page1.total == 3)) { case (?e) return ?e; case (null) {} };
    switch (Test.assertTrue(page1.items.size() == 2)) { case (?e) return ?e; case (null) {} };
    switch (Test.assertTrue(page1.items[0].id == "tx-3")) { case (?e) return ?e; case (null) {} };
    switch (Test.assertTrue(page1.items[1].id == "tx-2")) { case (?e) return ?e; case (null) {} };

    let page2 = TransactionRepo.listPage(store, user, 2, 2);
    switch (Test.assertTrue(page2.items.size() == 1)) { case (?e) return ?e; case (null) {} };
    switch (Test.assertTrue(page2.items[0].id == "tx-1")) { case (?e) return ?e; case (null) {} };

    let pageRepeat = TransactionRepo.listPage(store, user, 0, 2);
    switch (Test.assertTrue(pageRepeat.items[0].id == page1.items[0].id)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (Test.assertTrue(pageRepeat.items[1].id == page1.items[1].id)) {
      case (?e) return ?e;
      case (null) {};
    };

    // deposit sync must not double-credit the same ledger block
    let token = Ledger.icpTokenRef(TestPrincipals.canister());
    let depositStore = Transaction.emptyStore();
    let depositId = "dep-block-7";
    let depositRow : Transaction.TxRecord = {
      id = depositId;
      user;
      kind = #deposit;
      amount = 500_000;
      fee = 0;
      counterparty = null;
      token;
      blockIndex = ?7;
      status = #completed;
      createdAt = 100;
      memo = null;
    };
    func recordDepositIfNew(store : Transaction.TxStore, tx : Transaction.TxRecord) : Bool {
      switch (TransactionRepo.getByTransferId(store, tx.id)) {
        case (?_) false;
        case (null) {
          TransactionRepo.insert(store, tx);
          true;
        };
      };
    };
    switch (Test.assertTrue(recordDepositIfNew(depositStore, depositRow))) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (Test.assertTrue(not recordDepositIfNew(depositStore, depositRow))) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (Test.assertTrue(TransactionRepo.sumCompletedIn(depositStore, user) == 500_000)) {
      case (?e) return ?e;
      case (null) {};
    };

    null;
  };
};
