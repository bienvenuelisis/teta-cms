class TetaAuthCredentials {
  TetaAuthCredentials({
    this.g_client_id,
    this.g_client_secret,
    this.gh_client_id,
    this.gh_client_secret,
  });

  TetaAuthCredentials.fromJson(final Map<String, dynamic> json)
      : g_client_id = json['g_client_id'] as String?,
        g_client_secret = json['g_client_secret'] as String?,
        gh_client_id = json['gh_client_id'] as String?,
        gh_client_secret = json['gh_client_secret'] as String?;

  final String? g_client_id;
  final String? g_client_secret;
  final String? gh_client_id;
  final String? gh_client_secret;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'g_client_id': g_client_id,
        'g_client_secret': g_client_secret,
        'gh_client_id': gh_client_id,
        'gh_client_secret': gh_client_secret,
      };
  @override
  String toString() =>
      'TetaAuthCredentials { g_client_id: $g_client_id, g_client_secret: $g_client_secret }';
}
