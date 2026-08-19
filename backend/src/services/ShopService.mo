import Principal "mo:core/Principal";
import Caller "mo:pkg/principal/caller";
import Crud "mo:pkg/crud/crud";
import Id "mo:pkg/id/uuid";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Types "../types";
import ShopRepo "../repositories/ShopRepository";
import ShopStorage "../storage/ShopStorage";
import ShopValidator "../validators/ShopValidator";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";

module {
  public type ShopService = {
    store : ShopStorage.ShopMap;
    userStore : UserStorage.UserMap;
  };

  public func create(store : ShopStorage.ShopMap, userStore : UserStorage.UserMap) : ShopService {
    { store; userStore };
  };

  public func createShop(
    service : ShopService,
    caller : Principal,
    name : Text,
  ) : async Types.ApiResult<Types.Shop> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (ShopValidator.validateName(name)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };

    let userRole = switch (UserRepo.getById(service.userStore, caller)) {
      case (?user) { user.role };
      case (null) { #guest };
    };

    switch (Rbac.require(userRole, #write)) {
      case (?message) { return Result.err(Result.forbidden, message) };
      case (null) {};
    };

    let item : Types.Shop = {
      id = Id.fromPrincipal("shop", caller);
      name = name;
      owner = caller;
      createdAt = TimeNow.now();
    };
    ShopRepo.save(service.store, item);
    Result.ok(item);
  };

  public func getShop(service : ShopService, id : Text) : ?Types.Shop {
    ShopRepo.getById(service.store, id);
  };

  public func listShops(
    service : ShopService,
    offset : Nat,
    limit : Nat,
  ) : Types.ApiResult<{ items : [Types.Shop]; total : Nat }> {
    let all = ShopRepo.list(service.store);
    Result.ok(Crud.page(all, offset, limit));
  };

  public func count(service : ShopService) : Nat {
    ShopRepo.count(service.store);
  };
};
