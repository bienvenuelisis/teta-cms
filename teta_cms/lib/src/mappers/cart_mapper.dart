import 'package:teta_cms/src/models/store/cart.dart';

class CartMapper {
  TetaCart mapCart(final Map<String, dynamic> json) => TetaCart(
        id: json['_id'] as String,
        userId: json['user_id'] as String,
        content: json['content'] == null
            ? <TetaCartContent>[]
            : mapCartContentList(
                json['content'] as List<Map<String, dynamic>>,
              ),
      );

  List<TetaCart> mapCarts(final List<Map<String, dynamic>> json) =>
      json.map(mapCart).toList(growable: true);

  TetaCartContent mapCartContent(final Map<String, dynamic> json) =>
      TetaCartContent(
        id: json['_id'] as String,
        prodId: json['product_id'] as String,
        addedAt: DateTime.tryParse(json['added_at'] as String),
      );

  List<TetaCartContent> mapCartContentList(
    final List<Map<String, dynamic>> json,
  ) =>
      json.map(mapCartContent).toList(growable: true);
}
