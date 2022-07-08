/// Policies are useful to set rules and permissions in the db
class PolicyObject {
  /// Policies are useful to set rules and permissions in the db
  PolicyObject({
    required this.key,
    required this.value,
  });

  /// Generates a Policy from json
  PolicyObject.fromJson(final Map<String, dynamic> json)
      : key = json['key'] as String,
        value = json['value'] as String;

  /// The key field
  final String key;

  /// The value that field should be eq to
  final String value;
}
