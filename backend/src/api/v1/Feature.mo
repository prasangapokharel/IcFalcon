import Types "../../types";
import FeatureService "../../services/FeatureService";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  service : FeatureService.FeatureService,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func createFeature(name : Text) : async Types.ApiResult<Types.Feature> {
    await FeatureService.createFeature(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      name,
    );
  };

  public query func getFeature(id : Text) : async ?Types.Feature {
    FeatureService.getFeature(service, id);
  };

  public query func listFeatures(offset : Nat, limit : Nat) : async Types.ApiResult<{ items : [Types.Feature]; total : Nat }> {
    FeatureService.listFeatures(service, offset, limit);
  };
};
