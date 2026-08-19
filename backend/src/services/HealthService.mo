import Config "../config/Config";
import Types "../types";
import FeatureService "../services/FeatureService";
import UserService "../services/UserService";

module {
  public func status(
    featureService : FeatureService.FeatureService,
    userService : UserService.UserService,
  ) : Types.HealthStatus {
    {
      status = "ok";
      version = Config.version;
      featureCount = FeatureService.count(featureService);
      userCount = UserService.count(userService);
    };
  };
};
