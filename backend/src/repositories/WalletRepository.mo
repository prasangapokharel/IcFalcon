import Crud "mo:pkg/crud/crud";
import Principal "mo:core/Principal";
import Types "../types";
import WalletStorage "../storage/WalletStorage";

module {
  public func get(store : WalletStorage.Registry, user : Principal) : ?Types.WalletRegistration {
    Crud.principalGet(store, user);
  };

  public func save(store : WalletStorage.Registry, user : Principal, reg : Types.WalletRegistration) : () {
    Crud.principalAdd(store, user, reg);
  };

  public func isRegistered(store : WalletStorage.Registry, user : Principal) : Bool {
    switch (get(store, user)) {
      case (null) false;
      case (?_) true;
    };
  };

  public func count(store : WalletStorage.Registry) : Nat {
    Crud.principalSize(store);
  };
};
