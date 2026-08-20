import Array "mo:core/Array";
import Principal "mo:core/Principal";
import Result "mo:pkg/errors/result";
import Transaction "mo:pkg/transaction/transaction";
import Caller "mo:pkg/principal/caller";
import Types "../types";
import TransactionRepo "../repositories/TransactionRepository";

module {
  public type TransactionService = {
    txStore : Transaction.TxStore;
  };

  public func create(txStore : Transaction.TxStore) : TransactionService {
    { txStore };
  };

  func kindText(kind : Transaction.TxKind) : Text {
    switch (kind) {
      case (#deposit) { "deposit" };
      case (#withdraw) { "withdraw" };
      case (#transferOut) { "transferOut" };
      case (#transferIn) { "transferIn" };
      case (#fee) { "fee" };
    };
  };

  func statusText(status : Transaction.TxStatus) : Text {
    switch (status) {
      case (#pending) { "pending" };
      case (#completed) { "completed" };
      case (#failed) { "failed" };
    };
  };

  func toView(tx : Transaction.TxRecord) : Types.TxView {
    {
      id = tx.id;
      kind = kindText(tx.kind);
      amount = tx.amount;
      fee = tx.fee;
      status = statusText(tx.status);
      blockIndex = tx.blockIndex;
      createdAt = tx.createdAt;
    };
  };

  public func list(
    service : TransactionService,
    caller : Principal,
    offset : Nat,
    limit : Nat,
  ) : Types.ApiResult<{ items : [Types.TxView]; total : Nat }> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    let page = TransactionRepo.listPage(service.txStore, caller, offset, limit);
    let items = Array.map(page.items, toView);
    Result.ok({ items; total = page.total });
  };
};
