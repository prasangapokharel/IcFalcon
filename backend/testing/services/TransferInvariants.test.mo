import Principal "mo:core/Principal";
import TestPrincipals "../TestPrincipals";
import Test "mo:pkg/test/test";
import TransactionRepo "mo:app/repositories/TransactionRepository";
import TransferService "mo:app/services/TransferService";
import Wallet "mo:pkg/wallet/wallet";
import WalletService "mo:app/services/WalletService";
import WalletStorage "mo:app/storage/WalletStorage";
import UserStorage "mo:app/storage/UserStorage";
import TransactionStorage "mo:app/storage/TransactionStorage";
import MockLedger "../mocks/MockLedger";

persistent actor class Suite() {
  func testOverBalance(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    switch (
      await TransferService.send(transfer, alice, "tx-over", Principal.toText(bob), 1_000_000)
    ) {
      case (#ok _) return ?"must reject send when amount leaves no room for fee";
      case (#err _) {};
    };
    switch (Test.assertTrue(not TransactionRepo.hasCompletedStatus(txStore, "tx-over"))) {
      case (?e) return ?e;
      case (null) {};
    };
    null;
  };

  func testFeeReserve(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    switch (
      await TransferService.send(transfer, alice, "tx-fee-ok", Principal.toText(bob), 500_000)
    ) {
      case (#err _) return ?"must allow send when balance covers amount + fee";
      case (#ok({ blockIndex })) {
        switch (Test.assertTrue(blockIndex > 0)) { case (?e) return ?e; case (null) {} };
      };
    };
    null;
  };

  func testFailedLedger(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    await mock.setFailNext(true);
    switch (
      await TransferService.send(transfer, alice, "tx-fail", Principal.toText(bob), 100_000)
    ) {
      case (#ok _) return ?"ledger failure must not return ok";
      case (#err _) {};
    };
    switch (Test.assertTrue(not TransactionRepo.hasCompletedStatus(txStore, "tx-fail"))) {
      case (?e) return ?e;
      case (null) {};
    };
    null;
  };

  func testIdempotent(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    switch (
      await TransferService.send(transfer, alice, "tx-dup", Principal.toText(bob), 100_000)
    ) {
      case (#err _) return ?"first send should succeed";
      case (#ok({ blockIndex = firstBlock })) {
        switch (
          await TransferService.execute(transfer, alice, "tx-dup", Principal.toText(bob), 100_000)
        ) {
          case (#err _) return ?"duplicate transferId must replay ok";
          case (#ok({ blockIndex = secondBlock })) {
            switch (Test.assertTrue(firstBlock == secondBlock)) {
              case (?e) return ?e;
              case (null) {};
            };
          };
        };
      };
    };
    null;
  };

  func testInternalRows(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    switch (
      await TransferService.send(transfer, alice, "tx-internal", Principal.toText(bob), 200_000)
    ) {
      case (#err _) return ?"internal transfer should succeed";
      case (#ok _) {};
    };
    let aliceRows = TransactionRepo.listByUser(txStore, alice);
    let bobRows = TransactionRepo.listByUser(txStore, bob);
    var aliceOut = false;
    var bobIn = false;
    var bobDeposit = false;
    for (tx in aliceRows.vals()) {
      if (tx.id == "tx-internal" and tx.kind == #transferOut) { aliceOut := true };
    };
    for (tx in bobRows.vals()) {
      if (tx.id == "tx-internal-in" and tx.kind == #transferIn) { bobIn := true };
      if (tx.kind == #deposit) { bobDeposit := true };
    };
    if (not (aliceOut and bobIn and not bobDeposit)) {
      return ?"internal transfer must create two rows, not deposit credit";
    };
    let bobAccount = Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, bob));
    let bobLedgerBal = await mock.icrc1_balance_of(bobAccount);
    let bobIndexed = TransactionRepo.sumCompletedIn(txStore, bob);
    switch (Test.assertTrue(bobLedgerBal == bobIndexed and bobIndexed == 200_000)) {
      case (?_) return ?"recipient indexed inflows must match ledger (no double-credit on sync)";
      case (null) {};
    };
    null;
  };

  func testLedgerTruth(
    canister : Principal,
    alice : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    ignore WalletService.register(wallet, alice);
    await mock.setBalance(
      Wallet.toIcrcAccount(WalletService.custodialAccount(wallet, alice)),
      1_000_000,
    );
    switch (await WalletService.getBalance(wallet, alice)) {
      case (#err _) return ?"balance query failed";
      case (#ok({ amount })) {
        let indexed = TransactionRepo.sumCompletedIn(txStore, alice);
        switch (Test.assertTrue(amount == 1_000_000 and indexed == 0)) {
          case (?e) return ?e;
          case (null) {};
        };
      };
    };
    null;
  };

  func testPendingConflict(
    canister : Principal,
    alice : Principal,
    bob : Principal,
    ledgerId : Principal,
  ) : async ?Text {
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);
    let wallet = WalletService.createWithLedger(
      WalletStorage.createRegistry(),
      UserStorage.createUserMap(),
      ledgerId,
      canister,
      mock,
    );
    let txStore = TransactionStorage.createStore();
    let transfer = TransferService.createWithLedger(wallet, txStore, mock);
    ignore WalletService.register(wallet, alice);
    ignore WalletService.register(wallet, bob);
    let fromAccount = WalletService.custodialAccount(wallet, alice);
    TransactionRepo.insert(txStore, {
      id = "tx-inflight";
      user = alice;
      kind = #transferOut;
      amount = 100_000;
      fee = 10_000;
      counterparty = ?bob;
      token = fromAccount.token;
      blockIndex = null;
      status = #pending;
      createdAt = 0;
      memo = null;
    });
    switch (
      await TransferService.execute(
        transfer,
        alice,
        "tx-inflight",
        Principal.toText(bob),
        100_000,
      )
    ) {
      case (#ok _) return ?"in-flight transferId must return conflict";
      case (#err({ code })) {
        switch (Test.assertTrue(code == 409)) {
          case (?e) return ?e;
          case (null) {};
        };
      };
    };
    null;
  };

  public func run() : async ?Text {
    let canister = TestPrincipals.canister();
    let alice = TestPrincipals.alice();
    let bob = TestPrincipals.bob();
    let ledgerId = TestPrincipals.ledger();

    switch (await testOverBalance(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testFeeReserve(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testFailedLedger(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testIdempotent(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testInternalRows(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testLedgerTruth(canister, alice, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    switch (await testPendingConflict(canister, alice, bob, ledgerId)) {
      case (?e) return ?e;
      case (null) {};
    };
    null;
  };
};
