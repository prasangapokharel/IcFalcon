import Principal "mo:core/Principal";
import Crud "mo:pkg/crud/crud";
import Types "../types";
import UserStorage "../storage/UserStorage";

module {
  public func getById(store : UserStorage.UserMap, id : Principal) : ?Types.User {
    Crud.principalGet(store, id);
  };

  public func save(store : UserStorage.UserMap, user : Types.User) : () {
    Crud.principalAdd(store, user.id, user);
  };

  public func list(store : UserStorage.UserMap) : [Types.User] {
    Crud.principalValues(store);
  };

  public func count(store : UserStorage.UserMap) : Nat {
    Crud.principalSize(store);
  };
};
