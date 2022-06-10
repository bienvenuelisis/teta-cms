import 'package:teta_cms/src/models/store/cart.dart';

class CartMapper {
  TetaCart mapCart(final Map<String, dynamic> json) => TetaCart(
        id: json['id'] as String,
        userId: json['userId'] as String,
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
        id: json['id'] as String,
        prodId: json['prodId'] as String,
        addedAt: DateTime.tryParse(json['addedAt'] as String),
      );

  List<TetaCartContent> mapCartContentList(
    final List<Map<String, dynamic>> json,
  ) =>
      json.map(mapCartContent).toList(growable: true);
}
