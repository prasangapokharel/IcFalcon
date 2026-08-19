import Crud "mo:pkg/crud/crud";
import Types "../types";
import FeatureStorage "../storage/FeatureStorage";

module {
  public func getById(store : FeatureStorage.FeatureMap, id : Text) : ?Types.Feature {
    Crud.textGet(store, id);
  };

  public func save(store : FeatureStorage.FeatureMap, feature : Types.Feature) : () {
    Crud.textAdd(store, feature.id, feature);
  };

  public func remove(store : FeatureStorage.FeatureMap, id : Text) : () {
    Crud.textRemove(store, id);
  };

  public func list(store : FeatureStorage.FeatureMap) : [Types.Feature] {
    Crud.textValues(store);
  };

  public func count(store : FeatureStorage.FeatureMap) : Nat {
    Crud.textSize(store);
  };
};
