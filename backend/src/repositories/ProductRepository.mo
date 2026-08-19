import Crud "mo:pkg/crud/crud";
import Types "../types";
import ProductStorage "../storage/ProductStorage";

module {
  public func getById(store : ProductStorage.ProductMap, id : Text) : ?Types.Product {
    Crud.textGet(store, id);
  };

  public func save(store : ProductStorage.ProductMap, item : Types.Product) : () {
    Crud.textAdd(store, item.id, item);
  };

  public func remove(store : ProductStorage.ProductMap, id : Text) : () {
    Crud.textRemove(store, id);
  };

  public func list(store : ProductStorage.ProductMap) : [Types.Product] {
    Crud.textValues(store);
  };

  public func count(store : ProductStorage.ProductMap) : Nat {
    Crud.textSize(store);
  };
};
