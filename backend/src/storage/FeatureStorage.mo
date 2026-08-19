import Crud "mo:pkg/crud/crud";
import Types "../types";

module {
  public type FeatureMap = Crud.TextMap<Types.Feature>;

  public func createFeatureMap() : FeatureMap {
    Crud.textEmpty();
  };
};
