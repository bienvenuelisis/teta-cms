class TetaAuthCredentials {
  TetaAuthCredentials({
    this.g_client_id,
    this.g_client_secret,
  });

  final String? g_client_id;
  final String? g_client_secret;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'g_client_id': g_client_id,
        'g_client_secret': g_client_secret,
      };

  @override
  String toString() =>
      'TetaAuthCredentials { g_client_id: $g_client_id, g_client_secret: $g_client_secret }';
}
