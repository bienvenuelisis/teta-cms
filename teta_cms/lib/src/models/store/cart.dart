class TetaCart {
  TetaCart({
    required this.id,
    required this.userId,
    required this.content,
  });

  TetaCart.fromJson(final Map<String, dynamic> map)
      : id = map['id'] as String,
        userId = map['userId'] as String,
        content = (map['content'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (final dynamic e) =>
                  TetaCartContent.fromJson(e as Map<String, dynamic>),
            )
            .toList();

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

  TetaCartContent.fromJson(final Map<String, dynamic> map)
      : id = map['id'] as String,
        prodId = map['prodId'] as String,
        addedAt = DateTime.tryParse(map['addedAt'] as String);

  final String id;
  final String prodId;
  final DateTime? addedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'prodId': prodId,
        'addedAt': addedAt?.toIso8601String(),
      };
}
