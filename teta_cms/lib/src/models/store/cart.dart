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
        'id': id,
        'userId': userId,
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
        'id': id,
        'prodId': prodId,
        'addedAt': addedAt?.toIso8601String(),
      };
}
