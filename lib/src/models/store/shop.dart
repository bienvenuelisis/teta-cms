import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';

class TetaShop {
  TetaShop({
    required this.id,
    required this.currency,
    required this.products,
    required this.carts,
  });

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
