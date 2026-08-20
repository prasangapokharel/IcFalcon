import Array "mo:core/Array";
import Crud "mo:pkg/crud/crud";
import Int "mo:core/Int";
import Map "mo:core/Map";
import Order "mo:core/Order";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Transaction "mo:pkg/transaction/transaction";

module {
  func compareTx(a : Transaction.TxRecord, b : Transaction.TxRecord) : Order.Order {
    switch (Int.compare(b.createdAt, a.createdAt)) {
      case (#equal) Text.compare(a.id, b.id);
      case (other) other;
    };
  };

  public func insert(store : Transaction.TxStore, tx : Transaction.TxRecord) : () {
    Transaction.insert(store, tx);
  };

  public func remove(store : Transaction.TxStore, id : Text) : () {
    Map.remove(store, Text.compare, id);
  };

  public func getByTransferId(store : Transaction.TxStore, id : Text) : ?Transaction.TxRecord {
    Transaction.getByTransferId(store, id);
  };

  public func listByUser(store : Transaction.TxStore, user : Principal) : [Transaction.TxRecord] {
    Array.sort(Transaction.listByUser(store, user), compareTx);
  };

  public func listPage(
    store : Transaction.TxStore,
    user : Principal,
    offset : Nat,
    limit : Nat,
  ) : { items : [Transaction.TxRecord]; total : Nat } {
    let all = listByUser(store, user);
    Crud.page(all, offset, limit);
  };

  public func sumCompletedIn(store : Transaction.TxStore, user : Principal) : Nat {
    var total = 0;
    for (tx in listByUser(store, user).vals()) {
      switch (tx.kind, tx.status) {
        case (#transferIn, #completed) { total += tx.amount };
        case (#deposit, #completed) { total += tx.amount };
        case (_, _) {};
      };
    };
    total;
  };

  public func hasCompletedStatus(store : Transaction.TxStore, transferId : Text) : Bool {
    switch (getByTransferId(store, transferId)) {
      case (?tx) tx.status == #completed;
      case (null) false;
    };
  };
};
