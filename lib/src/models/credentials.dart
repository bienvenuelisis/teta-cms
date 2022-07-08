// ignore_for_file: non_constant_identifier_names

/// Model to save a project oauth providers credentials
class TetaAuthCredentials {
  /// Model to save a project oauth providers credentials
  TetaAuthCredentials({
    this.g_client_id,
    this.g_client_secret,
    this.gh_client_id,
    this.gh_client_secret,
    this.t_client_id,
    this.t_client_secret,
    this.a_client_id,
    this.a_client_secret,
  });

  /// Generate a TetaAuthCredentials from a json
  TetaAuthCredentials.fromJson(final Map<String, dynamic> json)
      : g_client_id = json['g_client_id'] as String?,
        g_client_secret = json['g_client_secret'] as String?,
        gh_client_id = json['gh_client_id'] as String?,
        gh_client_secret = json['gh_client_secret'] as String?,
        t_client_id = json['t_client_id'] as String?,
        t_client_secret = json['t_client_secret'] as String?,
        a_client_id = json['a_client_id'] as String?,
        a_client_secret = json['a_client_secret'] as String?;

  /// Google id
  final String? g_client_id;

  /// Google secret
  final String? g_client_secret;

  /// GitHub id
  final String? gh_client_id;

  /// GitHub secret
  final String? gh_client_secret;

  /// Twitter id
  final String? t_client_id;

  /// Twitter secret
  final String? t_client_secret;

  /// Appl id
  final String? a_client_id;

  /// Apple secret
  final String? a_client_secret;

  /// Generates a json from current instance
  Map<String, dynamic> toJson() => <String, dynamic>{
        'g_client_id': g_client_id,
        'g_client_secret': g_client_secret,
        'gh_client_id': gh_client_id,
        'gh_client_secret': gh_client_secret,
        't_client_id': t_client_id,
        't_client_secret': t_client_secret,
        'a_client_id': a_client_id,
        'a_client_secret': a_client_secret,
      };
  @override
  String toString() =>
      'TetaAuthCredentials { g_client_id: $g_client_id, g_client_secret: $g_client_secret }';
}
