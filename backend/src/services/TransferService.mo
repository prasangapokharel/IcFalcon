import Caller "mo:pkg/principal/caller";
import Icrc1 "mo:pkg/icrc1/icrc1";
import Principal "mo:core/Principal";
import RateLimit "mo:pkg/rate-limit/limit";
import Result "mo:pkg/errors/result";
import TimeNow "mo:pkg/time/now";
import Transaction "mo:pkg/transaction/transaction";
import Transfer "mo:pkg/transfer/transfer";
import Wallet "mo:pkg/wallet/wallet";
import Types "../types";
import TransactionRepo "../repositories/TransactionRepository";
import WalletRepo "../repositories/WalletRepository";
import WalletValidator "../validators/WalletValidator";
import WalletService "./WalletService";

module {
  let rateWindow : Int = 60_000_000_000;
  let rateMax : Nat = 10;

  public type TransferService = {
    wallet : WalletService.WalletService;
    txStore : Transaction.TxStore;
    ledger : Icrc1.LedgerActor;
    rateLimit : RateLimit.Store;
  };

  public func create(
    wallet : WalletService.WalletService,
    txStore : Transaction.TxStore,
  ) : TransferService {
    createWithLedger(wallet, txStore, wallet.ledger);
  };

  public func createWithLedger(
    wallet : WalletService.WalletService,
    txStore : Transaction.TxStore,
    ledger : Icrc1.LedgerActor,
  ) : TransferService {
    { wallet; txStore; ledger; rateLimit = RateLimit.empty() };
  };

  func checkTransferId(
    store : Transaction.TxStore,
    transferId : Text,
  ) : ?Types.ApiResult<Types.SendTransferResult> {
    switch (TransactionRepo.getByTransferId(store, transferId)) {
      case (?tx) {
        switch (tx.status) {
          case (#completed) {
            switch (tx.blockIndex) {
              case (?block) ?Result.ok({ transferId; blockIndex = block });
              case (null) ?Result.err(Result.badRequest, "transferId already used");
            };
          };
          case (#pending) ?Result.err(Result.conflict, "Transfer in flight");
          case (#failed) ?Result.err(Result.badRequest, "transferId already used");
        };
      };
      case (null) null;
    };
  };

  func validateSend(
    service : TransferService,
    caller : Principal,
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : ?Text {
    switch (Caller.requireAuth(caller)) {
      case (?message) return ?message;
      case (null) {};
    };
    if (not WalletRepo.isRegistered(service.wallet.registry, caller)) {
      return ?"Wallet not registered";
    };
    switch (WalletValidator.validateTransferId(transferId)) {
      case (?message) return ?message;
      case (null) {};
    };
    switch (WalletValidator.validateAmount(amount)) {
      case (?message) return ?message;
      case (null) {};
    };
    switch (WalletValidator.validateRecipient(toPrincipal)) {
      case (?message) return ?message;
      case (null) {};
    };
    let recipient = switch (WalletValidator.parsePrincipal(toPrincipal)) {
      case (null) return ?"Invalid principal";
      case (?p) p;
    };
    if (recipient == caller) return ?"Cannot send to yourself";
    null;
  };

  func buildRequest(
    service : TransferService,
    caller : Principal,
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : ?{ req : Transfer.TransferRequest; recipient : Principal } {
    let recipient = switch (WalletValidator.parsePrincipal(toPrincipal)) {
      case (null) return null;
      case (?p) p;
    };
    if (recipient == caller) return null;

    let fromAccount = WalletService.custodialAccount(service.wallet, caller);
    let toAccount = Wallet.toIcrcAccount(
      Wallet.deriveAccount(service.wallet.canisterId, recipient, fromAccount.token),
    );
    ?{
      recipient;
      req = {
        transferId;
        from = fromAccount;
        to = toAccount;
        amount;
        memo = null;
      };
    };
  };

  public func propose(
    service : TransferService,
    caller : Principal,
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.TransferPreview> {
    switch (validateSend(service, caller, transferId, toPrincipal, amount)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };
    switch (checkTransferId(service.txStore, transferId)) {
      case (?result) {
        switch (result) {
          case (#ok(_)) {
            return Result.err(Result.badRequest, "transferId already completed");
          };
          case (#err(e)) return #err(e);
        };
      };
      case (null) {};
    };
    let built = switch (buildRequest(service, caller, transferId, toPrincipal, amount)) {
      case (null) {
        return Result.err(Result.badRequest, "Invalid principal");
      };
      case (?value) value;
    };
    let balance = await service.ledger.icrc1_balance_of(
      Wallet.toIcrcAccount(built.req.from),
    );
    let fee = await service.ledger.icrc1_fee();
    switch (Transfer.validateRequest(built.req, balance, fee)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };
    Result.ok({
      transferId;
      toPrincipal;
      amount;
      fee;
      totalDebit = amount + fee;
      balance;
    });
  };

  public func execute(
    service : TransferService,
    caller : Principal,
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.SendTransferResult> {
    switch (validateSend(service, caller, transferId, toPrincipal, amount)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };
    if (not RateLimit.allow(service.rateLimit, caller, rateMax, rateWindow)) {
      return Result.err(Result.tooManyRequests, "Transfer rate limit exceeded");
    };
    switch (checkTransferId(service.txStore, transferId)) {
      case (?replay) return replay;
      case (null) {};
    };
    let built = switch (buildRequest(service, caller, transferId, toPrincipal, amount)) {
      case (null) {
        return Result.err(Result.badRequest, "Invalid principal");
      };
      case (?value) value;
    };

    let balance = await service.ledger.icrc1_balance_of(
      Wallet.toIcrcAccount(built.req.from),
    );
    let fee = await service.ledger.icrc1_fee();
    switch (Transfer.validateRequest(built.req, balance, fee)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };

    let now = TimeNow.now();
    TransactionRepo.insert(service.txStore, {
      id = transferId;
      user = caller;
      kind = Transaction.kindForSender();
      amount;
      fee;
      counterparty = ?built.recipient;
      token = built.req.from.token;
      blockIndex = null;
      status = #pending;
      createdAt = now;
      memo = null;
    });

    let raw = await service.ledger.icrc1_transfer(Transfer.buildTransferArgs(built.req, fee));
    let result = Transfer.mapResult(raw);

    switch (result) {
      case (#err({ message })) {
        TransactionRepo.remove(service.txStore, transferId);
        Result.err(Result.badRequest, message);
      };
      case (#ok({ blockIndex })) {
        TransactionRepo.remove(service.txStore, transferId);
        let recipientUser = if (WalletRepo.isRegistered(service.wallet.registry, built.recipient)) {
          ?built.recipient;
        } else {
          null;
        };
        for (row in Transfer.recordsForTransfer(built.req, result, fee, recipientUser, now).vals()) {
          TransactionRepo.insert(service.txStore, row);
        };
        Result.ok({ transferId; blockIndex });
      };
    };
  };

  public func send(
    service : TransferService,
    caller : Principal,
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.SendTransferResult> {
    await execute(service, caller, transferId, toPrincipal, amount);
  };
};
