import HealthApi "api/v1/Health";
import AuthApi "api/v1/Auth";
import FeatureApi "api/v1/Feature";
import ShopApi "api/v1/Shop";
import ProductApi "api/v1/Product";
import FeatureStorage "storage/FeatureStorage";
import ShopStorage "storage/ShopStorage";
import ProductStorage "storage/ProductStorage";
import UserStorage "storage/UserStorage";
import FeatureService "services/FeatureService";
import ShopService "services/ShopService";
import ProductService "services/ProductService";
import UserService "services/UserService";
import MiddlewareAuth "middleware/Auth";

persistent actor App {
  transient let mwConfig = MiddlewareAuth.prodConfig();

  let users = UserStorage.createUserMap();
  let features = FeatureStorage.createFeatureMap();
  let shops = ShopStorage.createShopMap();
  let products = ProductStorage.createProductMap();

  transient let userService = UserService.create(users);
  transient let featureService = FeatureService.create(features, users);
  transient let shopService = ShopService.create(shops, users);
  transient let productService = ProductService.create(products, users);

  include HealthApi(featureService, userService);
  include AuthApi(userService, mwConfig);
  include FeatureApi(featureService, mwConfig);
  include ShopApi(shopService, mwConfig);
  include ProductApi(productService, mwConfig);
};
