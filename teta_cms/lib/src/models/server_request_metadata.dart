class ServerRequestMetadata {
  ServerRequestMetadata({required this.token, required this.prjId});

  final String token;
  final int prjId;

  ServerRequestMetadata copyWith({
    final String? token,
    final int? prjId,
  }) =>
      ServerRequestMetadata(
        token: token ?? this.token,
        prjId: prjId ?? this.prjId,
      );
}
