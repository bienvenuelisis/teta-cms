import 'package:teta_cms/src/mappers/cart_mapper.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/models/store/shop.dart';

class ShopMapper {
  ShopMapper(this.productMapper, this.cartMapper);

  final ProductMapper productMapper;
  final CartMapper cartMapper;

  TetaShop mapShop(final Map<String, dynamic> json) => TetaShop(
        id: json['id'] as String,
        currency: json['currency'] as String,
        products: json['products'] == null
            ? <TetaProduct>[]
            : productMapper.mapProducts(
                json['products'] as List<Map<String, dynamic>>,
              ),
        carts: json['carts'] == null
            ? <TetaCart>[]
            : cartMapper.mapCarts(
                json['carts'] as List<Map<String, dynamic>>,
              ),
      );

  List<TetaShop> mapShops(final List<Map<String, dynamic>> json) =>
      json.map(mapShop).toList(
            growable: true,
          );
}
