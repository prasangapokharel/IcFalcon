import Array "mo:core/Array";
import Blob "mo:core/Blob";
import Caller "mo:pkg/principal/caller";
import Icrc1 "mo:pkg/icrc1/icrc1";
import Ledger "mo:pkg/ledger/ledger";
import Principal "mo:core/Principal";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Wallet "mo:pkg/wallet/wallet";
import Types "../types";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";
import WalletRepo "../repositories/WalletRepository";
import WalletStorage "../storage/WalletStorage";

module {
  public type WalletService = {
    registry : WalletStorage.Registry;
    users : UserStorage.UserMap;
    ledgerId : Principal;
    canisterId : Principal;
    ledger : Icrc1.LedgerActor;
  };

  public func create(
    registry : WalletStorage.Registry,
    users : UserStorage.UserMap,
    ledgerId : Principal,
    canisterId : Principal,
  ) : WalletService {
    let ledger : Icrc1.LedgerActor = actor (Principal.toText(ledgerId));
    createWithLedger(registry, users, ledgerId, canisterId, ledger);
  };

  public func createWithLedger(
    registry : WalletStorage.Registry,
    users : UserStorage.UserMap,
    ledgerId : Principal,
    canisterId : Principal,
    ledger : Icrc1.LedgerActor,
  ) : WalletService {
    { registry; users; ledgerId; canisterId; ledger };
  };

  func token(service : WalletService) : Ledger.TokenRef {
    Ledger.icpTokenRef(service.ledgerId);
  };

  func account(service : WalletService, user : Principal) : Wallet.CustodialAccount {
    Wallet.deriveAccount(service.canisterId, user, token(service));
  };

  func toDeposit(service : WalletService, user : Principal) : Types.WalletDeposit {
    let info = Wallet.depositInfo(account(service, user));
    {
      icrcOwner = info.icrcAccount.owner;
      icrcSubaccount = switch (info.icrcAccount.subaccount) {
        case (null) null;
        case (?sub) ?Array.toBlob(sub);
      };
      accountIdHex = info.accountIdHex;
      qrPayload = info.qrPayload;
    };
  };

  func requireRegistered(service : WalletService, caller : Principal) : ?Text {
    if (WalletRepo.isRegistered(service.registry, caller)) { null } else {
      ?"Wallet not registered";
    };
  };

  public func register(
    service : WalletService,
    caller : Principal,
  ) : Types.ApiResult<Types.WalletDeposit> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (WalletRepo.get(service.registry, caller)) {
      case (?_) { return Result.ok(toDeposit(service, caller)) };
      case (null) {};
    };

    WalletRepo.save(service.registry, caller, { registeredAt = TimeNow.now() });
    Result.ok(toDeposit(service, caller));
  };

  public func depositInfo(
    service : WalletService,
    caller : Principal,
  ) : Types.ApiResult<Types.WalletDeposit> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };
    switch (requireRegistered(service, caller)) {
      case (?message) { return Result.err(Result.notFound, message) };
      case (null) {};
    };
    Result.ok(toDeposit(service, caller));
  };

  public func getBalance(
    service : WalletService,
    caller : Principal,
  ) : async Types.ApiResult<Types.WalletBalance> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };
    switch (requireRegistered(service, caller)) {
      case (?message) { return Result.err(Result.notFound, message) };
      case (null) {};
    };

    let tok = token(service);
    let amount = await service.ledger.icrc1_balance_of(Wallet.toIcrcAccount(account(service, caller)));
    Result.ok({ amount; symbol = tok.symbol; decimals = tok.decimals });
  };

  public func treasury(
    service : WalletService,
    caller : Principal,
  ) : Types.ApiResult<Types.TreasurySummary> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    let role = switch (UserRepo.getById(service.users, caller)) {
      case (?user) user.role;
      case (null) { #guest };
    };
    switch (Rbac.require(role, #manage)) {
      case (?message) { return Result.err(Result.forbidden, message) };
      case (null) {};
    };

    Result.ok({
      registeredWallets = WalletRepo.count(service.registry);
      symbol = token(service).symbol;
    });
  };

  public func custodialAccount(service : WalletService, user : Principal) : Wallet.CustodialAccount {
    account(service, user);
  };
};
