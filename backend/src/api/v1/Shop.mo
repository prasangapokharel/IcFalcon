import Types "../../types";
import ShopService "../../services/ShopService";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  service : ShopService.ShopService,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func createShop(name : Text) : async Types.ApiResult<Types.Shop> {
    await ShopService.createShop(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      name,
    );
  };

  public query func getShop(id : Text) : async ?Types.Shop {
    ShopService.getShop(service, id);
  };

  public query func listShops(offset : Nat, limit : Nat) : async Types.ApiResult<{ items : [Types.Shop]; total : Nat }> {
    ShopService.listShops(service, offset, limit);
  };
};
