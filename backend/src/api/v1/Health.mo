import Types "../../types";
import HealthService "../../services/HealthService";
import FeatureService "../../services/FeatureService";
import UserService "../../services/UserService";

mixin (
  featureService : FeatureService.FeatureService,
  userService : UserService.UserService,
) {
  public query func ping() : async Text {
    "pong";
  };

  public query func status() : async Types.HealthStatus {
    HealthService.status(featureService, userService);
  };
};
