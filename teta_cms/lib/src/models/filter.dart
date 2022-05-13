import 'dart:convert';

enum FilterType { equal, like, gt, lt }

class Filter {
  Filter(this.key, this.value, {this.type = FilterType.like});

  String key;
  FilterType? type;
  String value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'key': key,
        'type': type,
        'value': value,
      };
}
