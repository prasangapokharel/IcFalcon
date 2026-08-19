import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type {{Name}}Map = Crud.TextMap<Types.{{Name}}>;

  public func create{{Name}}Map() : {{Name}}Map {
    Crud.textEmpty();
  };
};
