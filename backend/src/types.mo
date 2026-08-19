import Principal "mo:core/Principal";
import Result "mo:pkg/errors/result";
import Rbac "mo:pkg/rbac/rbac";

module {
  public type ApiError = Result.ApiError;
  public type ApiResult<T> = Result.ApiResult<T>;

  public type User = {
    id : Principal;
    username : Text;
    role : Rbac.Role;
    createdAt : Int;
  };

  public type Feature = {
    id : Text;
    name : Text;
    owner : Principal;
    createdAt : Int;
  };

  public type HealthStatus = {
    status : Text;
    version : Text;
    featureCount : Nat;
    userCount : Nat;
  };

  public type Product = {
    id : Text;
    name : Text;
    owner : Principal;
    createdAt : Int;
  };

  public type Shop = {
    id : Text;
    name : Text;
    owner : Principal;
    createdAt : Int;
  };

  public type UserProfile = {
    principal : Text;
    username : Text;
    role : Text;
    createdAt : Int;
  };
};
