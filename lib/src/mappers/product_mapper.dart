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
        price: json['price'] as num? ?? 0,
        count: json['count'] as num? ?? 0,
        isPublic: json['isPublic'] as bool? ?? false,
        description: json['description'] as String?,
        image: json['image'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  List<TetaProduct> mapProducts(final List<Map<String, dynamic>> products) =>
      products.map(mapProduct).toList(growable: true);
}
