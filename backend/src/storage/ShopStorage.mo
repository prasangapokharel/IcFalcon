import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type ShopMap = Crud.TextMap<Types.Shop>;

  public func createShopMap() : ShopMap {
    Crud.textEmpty();
  };
};
