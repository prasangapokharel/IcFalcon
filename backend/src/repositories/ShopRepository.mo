import Crud "mo:pkg/crud/crud";
import Types "../types";
import ShopStorage "../storage/ShopStorage";

module {
  public func getById(store : ShopStorage.ShopMap, id : Text) : ?Types.Shop {
    Crud.textGet(store, id);
  };

  public func save(store : ShopStorage.ShopMap, item : Types.Shop) : () {
    Crud.textAdd(store, item.id, item);
  };

  public func remove(store : ShopStorage.ShopMap, id : Text) : () {
    Crud.textRemove(store, id);
  };

  public func list(store : ShopStorage.ShopMap) : [Types.Shop] {
    Crud.textValues(store);
  };

  public func count(store : ShopStorage.ShopMap) : Nat {
    Crud.textSize(store);
  };
};
