import Principal "mo:core/Principal";
import Caller "mo:pkg/principal/caller";
import Crud "mo:pkg/crud/crud";
import Id "mo:pkg/id/uuid";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Types "../types";
import ProductRepo "../repositories/ProductRepository";
import ProductStorage "../storage/ProductStorage";
import ProductValidator "../validators/ProductValidator";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";

module {
  public type ProductService = {
    store : ProductStorage.ProductMap;
    userStore : UserStorage.UserMap;
  };

  public func create(store : ProductStorage.ProductMap, userStore : UserStorage.UserMap) : ProductService {
    { store; userStore };
  };

  public func createProduct(
    service : ProductService,
    caller : Principal,
    name : Text,
  ) : async Types.ApiResult<Types.Product> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (ProductValidator.validateName(name)) {
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

    let item : Types.Product = {
      id = Id.fromPrincipal("product", caller);
      name = name;
      owner = caller;
      createdAt = TimeNow.now();
    };
    ProductRepo.save(service.store, item);
    Result.ok(item);
  };

  public func getProduct(service : ProductService, id : Text) : ?Types.Product {
    ProductRepo.getById(service.store, id);
  };

  public func listProducts(
    service : ProductService,
    offset : Nat,
    limit : Nat,
  ) : Types.ApiResult<{ items : [Types.Product]; total : Nat }> {
    let all = ProductRepo.list(service.store);
    Result.ok(Crud.page(all, offset, limit));
  };

  public func count(service : ProductService) : Nat {
    ProductRepo.count(service.store);
  };
};
