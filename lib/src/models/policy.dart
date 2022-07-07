class PolicyObject {
  PolicyObject({
    required this.key,
    required this.value,
  });

  PolicyObject.fromJson(final Map<String, dynamic> json)
      : key = json['key'] as String,
        value = json['value'] as String;

  final String key;
  final String value;
}
