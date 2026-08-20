import Types "../../types";
import WalletService "../../services/WalletService";
import TransferService "../../services/TransferService";
import TransactionService "../../services/TransactionService";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  walletService : WalletService.WalletService,
  transferService : TransferService.TransferService,
  transactionService : TransactionService.TransactionService,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func registerWallet() : async Types.ApiResult<Types.WalletDeposit> {
    WalletService.register(
      walletService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
    );
  };

  public shared query ({ caller }) func depositInfo() : async Types.ApiResult<Types.WalletDeposit> {
    WalletService.depositInfo(
      walletService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
    );
  };

  public shared ({ caller }) func getBalance() : async Types.ApiResult<Types.WalletBalance> {
    await WalletService.getBalance(
      walletService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
    );
  };

  public shared ({ caller }) func proposeTransfer(
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.TransferPreview> {
    await TransferService.propose(
      transferService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      transferId,
      toPrincipal,
      amount,
    );
  };

  public shared ({ caller }) func executeTransfer(
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.SendTransferResult> {
    await TransferService.execute(
      transferService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      transferId,
      toPrincipal,
      amount,
    );
  };

  public shared ({ caller }) func sendTransfer(
    transferId : Text,
    toPrincipal : Text,
    amount : Nat,
  ) : async Types.ApiResult<Types.SendTransferResult> {
    await TransferService.execute(
      transferService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      transferId,
      toPrincipal,
      amount,
    );
  };

  public shared query ({ caller }) func listTransactions(
    offset : Nat,
    limit : Nat,
  ) : async Types.ApiResult<{ items : [Types.TxView]; total : Nat }> {
    TransactionService.list(
      transactionService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      offset,
      limit,
    );
  };

  public shared query ({ caller }) func adminTreasury() : async Types.ApiResult<Types.TreasurySummary> {
    WalletService.treasury(
      walletService,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
    );
  };
};
