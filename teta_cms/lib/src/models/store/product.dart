class TetaProduct {
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

  TetaProduct.fromJson(final Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        price = map['price'] as double? ?? 0,
        count = map['count'] as int? ?? 0,
        isPublic = map['isPublic'] as bool? ?? false,
        description = map['description'] as String?,
        image = map['image'] as String?,
        metadata = map['metadata'] as Map<String, dynamic>;

  final String id;
  final String name;
  final String? description;
  final double price;
  final int count;
  final String? image;
  final bool isPublic;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'count': count,
        'image': image,
        'isPublic': isPublic,
        'metadata': metadata,
      };
}
