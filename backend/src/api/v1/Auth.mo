import Types "../../types";
import UserService "../../services/UserService";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  service : UserService.UserService,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func register(username : Text) : async Types.ApiResult<Types.UserProfile> {
    await UserService.register(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      username,
    );
  };

  public shared query ({ caller }) func me() : async Types.ApiResult<Types.UserProfile> {
    UserService.getProfile(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
    );
  };
};
