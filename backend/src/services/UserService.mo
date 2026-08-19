import Principal "mo:core/Principal";
import Caller "mo:pkg/principal/caller";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Types "../types";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";
import UserValidator "../validators/UserValidator";

module {
  public type UserService = {
    storage : UserStorage.UserMap;
  };

  public func create(storage : UserStorage.UserMap) : UserService {
    { storage };
  };

  public func register(
    service : UserService,
    caller : Principal,
    username : Text,
  ) : async Types.ApiResult<Types.UserProfile> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (UserValidator.validateUsername(username)) {
      case (?message) { return Result.err(Result.badRequest, message) };
      case (null) {};
    };

    switch (UserRepo.getById(service.storage, caller)) {
      case (?_) { return Result.err(Result.badRequest, "User already exists") };
      case (null) {};
    };

    let user : Types.User = {
      id = caller;
      username = username;
      role = #member;
      createdAt = TimeNow.now();
    };
    UserRepo.save(service.storage, user);
    Result.ok(toProfile(user));
  };

  public func getProfile(service : UserService, caller : Principal) : Types.ApiResult<Types.UserProfile> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (UserRepo.getById(service.storage, caller)) {
      case (?user) { Result.ok(toProfile(user)) };
      case (null) { Result.err(Result.notFound, "User not found") };
    };
  };

  public func count(service : UserService) : Nat {
    UserRepo.count(service.storage);
  };

  func toProfile(user : Types.User) : Types.UserProfile {
    {
      principal = Principal.toText(user.id);
      username = user.username;
      role = Rbac.toText(user.role);
      createdAt = user.createdAt;
    };
  };
};
