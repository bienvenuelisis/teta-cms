/// Cart Model
class TetaCart {
  /// Cart Model
  TetaCart({
    required this.id,
    required this.userId,
    required this.content,
  });

  /// Cart id
  final String id;

  /// The user id who created the cart
  final String userId;

  /// Cart content
  final List<TetaCartContent> content;

  /// Generate a json from the model
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'user_id': userId,
        'content': content.map((final e) => e.toJson()).toList(),
      };
}

/// Content of the Teta Cart
class TetaCartContent {
  /// Content of the Teta Cart
  TetaCartContent({
    required this.id,
    required this.prodId,
    required this.addedAt,
  });

  /// Id of the cart content
  final String id;

  /// Project id
  final String prodId;

  /// When the product is added in the cart
  final DateTime? addedAt;

  /// Generate a json from the model
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'product_id': prodId,
        'added_at': addedAt?.toIso8601String(),
      };
}
