/// Model for Teta UI
class RowObject {
  /// Model for Teta UI
  RowObject({
    required this.name,
    required this.type,
    required this.value,
  });

  /// Generate a RowObject from json
  RowObject.fromJson(final Map<String, String> json)
      : name = json['name']!,
        type = json['type']!,
        value = json['value'];

  /// Field name
  String name;

  /// Field type
  String type;

  /// Field value
  dynamic value;

  /// Generates a json from current model
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'value': value,
      };

  @override
  String toString() =>
      'RowObject { name: $name, type: $type, defaultValue: $value }';
}
