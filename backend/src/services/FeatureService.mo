import Principal "mo:core/Principal";
import Caller "mo:pkg/principal/caller";
import Crud "mo:pkg/crud/crud";
import Id "mo:pkg/id/uuid";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";
import TimeNow "mo:pkg/time/now";
import Types "../types";
import FeatureRepo "../repositories/FeatureRepository";
import FeatureStorage "../storage/FeatureStorage";
import FeatureValidator "../validators/FeatureValidator";
import UserRepo "../repositories/UserRepository";
import UserStorage "../storage/UserStorage";

module {
  public type FeatureService = {
    featureStore : FeatureStorage.FeatureMap;
    userStore : UserStorage.UserMap;
  };

  public func create(
    featureStore : FeatureStorage.FeatureMap,
    userStore : UserStorage.UserMap,
  ) : FeatureService {
    { featureStore; userStore };
  };

  public func createFeature(
    service : FeatureService,
    caller : Principal,
    name : Text,
  ) : async Types.ApiResult<Types.Feature> {
    switch (Caller.requireAuth(caller)) {
      case (?message) { return Result.err(Result.unauthorized, message) };
      case (null) {};
    };

    switch (FeatureValidator.validateName(name)) {
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

    let feature : Types.Feature = {
      id = Id.fromPrincipal("feature", caller);
      name = name;
      owner = caller;
      createdAt = TimeNow.now();
    };
    FeatureRepo.save(service.featureStore, feature);
    Result.ok(feature);
  };

  public func getFeature(service : FeatureService, id : Text) : ?Types.Feature {
    FeatureRepo.getById(service.featureStore, id);
  };

  public func listFeatures(
    service : FeatureService,
    offset : Nat,
    limit : Nat,
  ) : Types.ApiResult<{ items : [Types.Feature]; total : Nat }> {
    let all = FeatureRepo.list(service.featureStore);
    let page = Crud.page(all, offset, limit);
    Result.ok(page);
  };

  public func count(service : FeatureService) : Nat {
    FeatureRepo.count(service.featureStore);
  };
};
