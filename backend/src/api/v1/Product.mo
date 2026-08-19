import Types "../../types";
import ProductService "../../services/ProductService";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  service : ProductService.ProductService,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func createProduct(name : Text) : async Types.ApiResult<Types.Product> {
    await ProductService.createProduct(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      name,
    );
  };

  public query func getProduct(id : Text) : async ?Types.Product {
    ProductService.getProduct(service, id);
  };

  public query func listProducts(offset : Nat, limit : Nat) : async Types.ApiResult<{ items : [Types.Product]; total : Nat }> {
    ProductService.listProducts(service, offset, limit);
  };
};
