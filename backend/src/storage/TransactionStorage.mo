import Transaction "mo:pkg/transaction/transaction";

module {
  public func createStore() : Transaction.TxStore {
    Transaction.emptyStore();
  };
};
