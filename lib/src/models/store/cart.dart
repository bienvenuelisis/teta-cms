class TetaCart {
  TetaCart({
    required this.id,
    required this.userId,
    required this.content,
  });

  final String id;
  final String userId;
  final List<TetaCartContent> content;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'user_id': userId,
        'content': content.map((final e) => e.toJson()).toList(),
      };
}

class TetaCartContent {
  TetaCartContent({
    required this.id,
    required this.prodId,
    required this.addedAt,
  });

  final String id;
  final String prodId;
  final DateTime? addedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'product_id': prodId,
        'added_at': addedAt?.toIso8601String(),
      };
}
