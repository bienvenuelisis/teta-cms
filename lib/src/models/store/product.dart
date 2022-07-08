/// Product model
class TetaProduct {
  /// Product model
  TetaProduct({
    required this.id,
    required this.name,
    this.price = 0.0,
    this.count = 0,
    this.isPublic = false,
    this.description,
    this.image,
    this.metadata,
  });

  /// Product id
  final String id;

  /// Product name
  final String name;

  /// Product description
  final String? description;

  /// Product price
  final num price;

  /// Product count
  final num count;

  /// Product image
  final String? image;

  /// Is the product public?
  final bool isPublic;

  /// Product metadata
  final Map<String, dynamic>? metadata;

  /// Generate a model from a json schema
  static TetaProduct fromSchema(final Map<String, String> json) => TetaProduct(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        price: double.tryParse(json['price'] ?? '') ?? 0,
        count: int.tryParse(json['count'] ?? '') ?? 0,
        isPublic: (json['isPublic'] ?? 'false').toLowerCase() == 'true',
        description: json['description'],
        image: json['image'],
        metadata: <String, dynamic>{},
      );

  /// Generate a json from the model
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'name': name,
        'description': description,
        'price': price,
        'count': count,
        'image': image,
        'isPublic': isPublic,
        'metadata': metadata,
      };
}
