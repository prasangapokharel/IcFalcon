import Principal "mo:core/Principal";
import HealthApi "api/v1/Health";
import AuthApi "api/v1/Auth";
import FeatureApi "api/v1/Feature";
import ShopApi "api/v1/Shop";
import ProductApi "api/v1/Product";
import WalletApi "api/v1/Wallet";
import Config "config/Config";
import FeatureStorage "storage/FeatureStorage";
import ShopStorage "storage/ShopStorage";
import ProductStorage "storage/ProductStorage";
import UserStorage "storage/UserStorage";
import WalletStorage "storage/WalletStorage";
import TransactionStorage "storage/TransactionStorage";
import FeatureService "services/FeatureService";
import ShopService "services/ShopService";
import ProductService "services/ProductService";
import UserService "services/UserService";
import WalletService "services/WalletService";
import TransferService "services/TransferService";
import TransactionService "services/TransactionService";
import MiddlewareAuth "middleware/Auth";

persistent actor App {
  transient let mwConfig = MiddlewareAuth.prodConfig();
  let canisterId = Principal.fromActor(App);

  let users = UserStorage.createUserMap();
  let features = FeatureStorage.createFeatureMap();
  let shops = ShopStorage.createShopMap();
  let products = ProductStorage.createProductMap();
  let walletRegistry = WalletStorage.createRegistry();
  let txStore = TransactionStorage.createStore();

  transient let userService = UserService.create(users);
  transient let featureService = FeatureService.create(features, users);
  transient let shopService = ShopService.create(shops, users);
  transient let productService = ProductService.create(products, users);
  transient let walletService = WalletService.create(
    walletRegistry,
    users,
    Config.icpLedgerId(),
    canisterId,
  );
  transient let transferService = TransferService.create(walletService, txStore);
  transient let transactionService = TransactionService.create(txStore);

  include HealthApi(featureService, userService);
  include AuthApi(userService, mwConfig);
  include FeatureApi(featureService, mwConfig);
  include ShopApi(shopService, mwConfig);
  include ProductApi(productService, mwConfig);
  include WalletApi(walletService, transferService, transactionService, mwConfig);
};
