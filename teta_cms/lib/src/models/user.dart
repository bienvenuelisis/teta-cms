class TetaUser {
  TetaUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.provider,
    required this.createdAt,
    this.isLogged = false,
  });

  TetaUser.fromJson(final Map<String, dynamic>? json)
      : uid = json?['uid'] as String?,
        name = json?['name'] as String?,
        email = json?['email'] as String?,
        provider = json?['provider'] as String?,
        createdAt = json?['created_at'] as String?,
        isLogged = json?.keys.isNotEmpty ?? false;

  final bool isLogged;
  final String? uid;
  final String? name;
  final String? email;
  final String? provider;
  final String? createdAt;
}
