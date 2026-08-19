import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type ProductMap = Crud.TextMap<Types.Product>;

  public func createProductMap() : ProductMap {
    Crud.textEmpty();
  };
};
