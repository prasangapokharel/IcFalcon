import Principal "mo:core/Principal";
import Caller "mo:pkg/principal/caller";
import Crud "mo:pkg/crud/crud";
import Id "mo:pkg/id/uuid";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Types "../types";
import {{Name}}Repo "../repositories/{{Name}}Repository";
import {{Name}}Storage "../storage/{{Name}}Storage";
import {{Name}}Validator "../validators/{{Name}}Validator";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";

module {
  public type {{Name}}Service = {
    store : {{Name}}Storage.{{Name}}Map;
    userStore : UserStorage.UserMap;
  };

  public func create(store : {{Name}}Storage.{{Name}}Map, userStore : UserStorage.UserMap) : {{Name}}Service {
    { store; userStore };
  };

  public func create{{Name}}(
    service : {{Name}}Service,
    caller : Principal,
    name : Text,
  ) : async Types.ApiResult<Types.{{Name}}> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch ({{Name}}Validator.validateName(name)) {
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

    let item : Types.{{Name}} = {
      id = Id.fromPrincipal("{{name}}", caller);
      name = name;
      owner = caller;
      createdAt = TimeNow.now();
    };
    {{Name}}Repo.save(service.store, item);
    Result.ok(item);
  };

  public func get{{Name}}(service : {{Name}}Service, id : Text) : ?Types.{{Name}} {
    {{Name}}Repo.getById(service.store, id);
  };

  public func list{{Name}}s(
    service : {{Name}}Service,
    offset : Nat,
    limit : Nat,
  ) : Types.ApiResult<{ items : [Types.{{Name}}]; total : Nat }> {
    let all = {{Name}}Repo.list(service.store);
    Result.ok(Crud.page(all, offset, limit));
  };

  public func count(service : {{Name}}Service) : Nat {
    {{Name}}Repo.count(service.store);
  };
};
