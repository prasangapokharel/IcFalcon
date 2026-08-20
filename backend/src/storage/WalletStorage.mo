import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type Registry = Crud.PrincipalMap<Types.WalletRegistration>;

  public func createRegistry() : Registry {
    Crud.principalEmpty();
  };
};
