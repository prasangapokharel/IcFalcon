import TestPrincipals "../TestPrincipals";
import Test "mo:pkg/test/test";
import WalletRepo "mo:app/repositories/WalletRepository";
import WalletService "mo:app/services/WalletService";
import WalletStorage "mo:app/storage/WalletStorage";
import UserStorage "mo:app/storage/UserStorage";
import MockLedger "../mocks/MockLedger";

persistent actor class Suite() {
  public func run() : async ?Text {
    let registry = WalletStorage.createRegistry();
    let users = UserStorage.createUserMap();
    let caller = TestPrincipals.alice();
    let canister = TestPrincipals.canister();
    let ledger = TestPrincipals.ledger();
    let mock = await MockLedger.MockLedger();
    await mock.setOwner(canister);

    let service = WalletService.createWithLedger(registry, users, ledger, canister, mock);

    switch (WalletService.register(service, caller)) {
      case (#err _) return ?"register should succeed";
      case (#ok(deposit)) {
        switch (Test.assertTrue(deposit.accountIdHex.size() == 64)) {
          case (?e) return ?e;
          case (null) {};
        };
      };
    };

    switch (Test.assertTrue(WalletRepo.isRegistered(registry, caller))) {
      case (?e) return ?e;
      case (null) {};
    };

    switch (WalletService.depositInfo(service, TestPrincipals.anonymous())) {
      case (#ok _) return ?"anonymous should not get deposit";
      case (#err _) {};
    };

    null;
  };
};
