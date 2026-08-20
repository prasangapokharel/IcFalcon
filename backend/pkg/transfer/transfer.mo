import Icrc1 "mo:pkg/icrc1/icrc1";
import Ledger "mo:pkg/ledger/ledger";
import Transaction "mo:pkg/transaction/transaction";
import Wallet "mo:pkg/wallet/wallet";

module {
  public type TransferRequest = {
    transferId : Text;
    from : Wallet.CustodialAccount;
    to : Icrc1.Account;
    amount : Nat;
    memo : ?[Nat8];
  };

  public type TransferResult = {
    #ok : { blockIndex : Nat };
    #err : { code : Text; message : Text };
  };

  public type IdempotencyStatus = { #pending; #completed; #failed };

  public type IdempotencyRecord = {
    transferId : Text;
    status : IdempotencyStatus;
    blockIndex : ?Nat;
    message : ?Text;
  };

  public func validateRequest(
    req : TransferRequest,
    balance : Nat,
    fee : Nat,
  ) : ?Text {
    if (req.amount == 0) return ?"amount must be greater than zero";
    if (req.transferId.size() == 0) return ?"transferId is required";
    Ledger.validateAmount(req.amount, fee, balance);
  };

  public func buildTransferArgs(
    req : TransferRequest,
    fee : Nat,
  ) : Icrc1.TransferArgs {
    Icrc1.buildTransfer(?req.from.subaccount, req.to, req.amount, ?fee);
  };

  public func mapResult(raw : Icrc1.TransferResult) : TransferResult {
    switch (raw) {
      case (#Ok(blockIndex)) { #ok({ blockIndex }) };
      case (#Err(error)) {
        #err({ code = "ledger_error"; message = Icrc1.errorText(error) });
      };
    };
  };

  public func recordsForTransfer(
    req : TransferRequest,
    result : TransferResult,
    fee : Nat,
    recipientUser : ?Principal,
    now : Int,
  ) : [Transaction.TxRecord] {
    switch (result) {
      case (#err _) { [] };
      case (#ok({ blockIndex })) {
        let senderRow : Transaction.TxRecord = {
          id = req.transferId;
          user = req.from.user;
          kind = Transaction.kindForSender();
          amount = req.amount;
          fee;
          counterparty = recipientUser;
          token = req.from.token;
          blockIndex = ?blockIndex;
          status = #completed;
          createdAt = now;
          memo = null;
        };
        switch (recipientUser) {
          case (null) { [senderRow] };
          case (?recipient) {
            let recipientRow : Transaction.TxRecord = {
              id = req.transferId # "-in";
              user = recipient;
              kind = Transaction.kindForRecipient();
              amount = req.amount;
              fee = 0;
              counterparty = ?req.from.user;
              token = req.from.token;
              blockIndex = ?blockIndex;
              status = #completed;
              createdAt = now;
              memo = null;
            };
            [senderRow, recipientRow];
          };
        };
      };
    };
  };
};
