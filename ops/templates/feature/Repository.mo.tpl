import Crud "mo:pkg/crud/crud";
import Types "../types";
import {{Name}}Storage "../storage/{{Name}}Storage";

module {
  public func getById(store : {{Name}}Storage.{{Name}}Map, id : Text) : ?Types.{{Name}} {
    Crud.textGet(store, id);
  };

  public func save(store : {{Name}}Storage.{{Name}}Map, item : Types.{{Name}}) : () {
    Crud.textAdd(store, item.id, item);
  };

  public func remove(store : {{Name}}Storage.{{Name}}Map, id : Text) : () {
    Crud.textRemove(store, id);
  };

  public func list(store : {{Name}}Storage.{{Name}}Map) : [Types.{{Name}}] {
    Crud.textValues(store);
  };

  public func count(store : {{Name}}Storage.{{Name}}Map) : Nat {
    Crud.textSize(store);
  };
};
