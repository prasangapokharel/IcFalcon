import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type UserMap = Crud.PrincipalMap<Types.User>;

  public func createUserMap() : UserMap {
    Crud.principalEmpty();
  };
};
