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
