import 'package:equatable/equatable.dart';

class RowObject extends Equatable {
  RowObject({
    required this.name,
    required this.type,
    required this.value,
  });

  RowObject.fromJson(final Map<String, String> json)
      : name = json['name']!,
        type = json['type']!,
        value = json['value'];

  String name;
  String type;
  dynamic value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'value': value,
      };

  @override
  List<Object?> get props => [
        name,
        type,
        value,
      ];

  @override
  String toString() =>
      'RowObject { name: $name, type: $type, defaultValue: $value }';
}
