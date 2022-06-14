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

  final String id;
  final String name;
  final String? description;
  final double price;
  final int count;
  final String? image;
  final bool isPublic;
  final Map<String, dynamic>? metadata;

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
