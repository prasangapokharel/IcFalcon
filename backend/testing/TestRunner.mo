import Debug "mo:core/Debug";
import TransferInvariantsTest "services/TransferInvariants.test";
import LedgerTruthTest "pkg/LedgerTruth.test";
import MoneyTest "pkg/Money.test";
import TransactionTest "pkg/Transaction.test";
import TransferTest "pkg/Transfer.test";
import WalletTest "services/WalletService.test";

persistent actor TestRunner {
  public func runAll() : async () {
    func runSync(name : Text, run : () -> ?Text) : () {
      switch (run()) {
        case (?err) {
          Debug.print(name # " failed: " # err);
          assert false;
        };
        case (null) {};
      };
    };

    runSync("Money.test", MoneyTest.run);
    runSync("Transfer.test", TransferTest.run);
    runSync("Transaction.test", TransactionTest.run);
    runSync("LedgerTruth.test", LedgerTruthTest.run);

    let walletSuite = await WalletTest.Suite();
    switch (await walletSuite.run()) {
      case (?err) {
        Debug.print("WalletService.test failed: " # err);
        assert false;
      };
      case (null) {};
    };

    let transferSuite = await TransferInvariantsTest.Suite();
    switch (await transferSuite.run()) {
      case (?err) {
        Debug.print("TransferInvariants.test failed: " # err);
        assert false;
      };
      case (null) {};
    };

    Debug.print("all tests passed");
  };
};

await TestRunner.runAll();
