import 'package:teta_cms/src/models/store/product.dart';

/// This class handles the deserialization of Products
///
/// Instead of putting the fromJson code in the Data class,
/// we delegate the the task to a DataMapper.
///
/// With this approach we can decouple the code and write unit tests more easily.
class ProductMapper {
  TetaProduct mapProduct(final Map<String, dynamic> json) => TetaProduct(
        id: json['_id'] as String,
        name: json['name'] as String? ?? '',
        price: json['price'] as double? ?? 0,
        count: json['count'] as int? ?? 0,
        isPublic: json['isPublic'] as bool? ?? false,
        description: json['description'] as String?,
        image: json['image'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  TetaProduct fromSchema(final Map<String, String> json) => TetaProduct(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        price: double.tryParse(json['price'] ?? '') ?? 0,
        count: int.tryParse(json['count'] ?? '') ?? 0,
        isPublic: (json['isPublic'] ?? 'false').toLowerCase() == 'true',
        description: json['description'],
        image: json['image'],
        metadata: <String, dynamic>{},
      );

  List<TetaProduct> mapProducts(final List<Map<String, dynamic>> products) =>
      products.map(mapProduct).toList(growable: true);
}
