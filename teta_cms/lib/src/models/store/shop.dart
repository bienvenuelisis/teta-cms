import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';

class TetaShop {
  TetaShop({
    required this.id,
    required this.currency,
    required this.products,
    required this.carts,
  });

  TetaShop.fromJson(final Map<String, dynamic> map)
      : id = map['id'] as String,
        currency = map['currency'] as String,
        products = (map['products'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (final dynamic e) =>
                  TetaProduct.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        carts = (map['carts'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (final dynamic e) => TetaCart.fromJson(e as Map<String, dynamic>),
            )
            .toList();

  final String id;
  final String currency;
  final List<TetaProduct> products;
  final List<TetaCart> carts;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'currency': currency,
        'products': products.map((final e) => e.toJson()).toList(),
        'carts': carts.map((final e) => e.toJson()).toList(),
      };
}
