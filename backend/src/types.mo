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

  public type WalletRegistration = {
    registeredAt : Int;
  };

  public type WalletDeposit = {
    icrcOwner : Principal;
    icrcSubaccount : ?Blob;
    accountIdHex : Text;
    qrPayload : Text;
  };

  public type WalletBalance = {
    amount : Nat;
    symbol : Text;
    decimals : Nat8;
  };

  public type TxView = {
    id : Text;
    kind : Text;
    amount : Nat;
    fee : Nat;
    status : Text;
    blockIndex : ?Nat;
    createdAt : Int;
  };

  public type SendTransferResult = {
    transferId : Text;
    blockIndex : Nat;
  };

  public type TransferPreview = {
    transferId : Text;
    toPrincipal : Text;
    amount : Nat;
    fee : Nat;
    totalDebit : Nat;
    balance : Nat;
  };

  public type TreasurySummary = {
    registeredWallets : Nat;
    symbol : Text;
  };
};
