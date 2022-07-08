import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';

/// Shop model
class TetaShop {
  /// Shop model
  TetaShop({
    required this.id,
    required this.currency,
    required this.products,
    required this.carts,
  });

  /// Shop id
  final String id;

  /// Shop currency
  final String currency;

  /// Product of the shop
  final List<TetaProduct> products;

  /// Carts of the shop
  final List<TetaCart> carts;

  /// Generate a json from the model
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'currency': currency,
        'products': products.map((final e) => e.toJson()).toList(),
        'carts': carts.map((final e) => e.toJson()).toList(),
      };
}
