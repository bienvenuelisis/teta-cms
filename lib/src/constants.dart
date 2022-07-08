/// Global constant for all the package
class Constants {
  /// Key to detect docs id
  static const String docId = '_id';

  /// Key to detect prj id
  static const String prjIdKey = 'prj_id';

  static const String _host = 'cms.teta.so';
  static const String _port = '9840';

  /// Standard Teta url
  static const String tetaUrl = 'https://$_host:$_port/';

  /// Default Http headers
  static const Map<String, String> defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
  };

  /// Store url for products
  static const String storeProductUrl =
      'https://cms.teta.so:9840/shop/product/';

  /// Store url for shop
  static const String storeUrl = 'https://cms.teta.so:9840/shop/';

  /// Store url for cart
  static const String storeCartUrl = 'https://cms.teta.so:9840/shop/cart/';

  /// Analytics url
  static const String analyticsUrl = 'https://analytics.teta.so:8001/';
}
