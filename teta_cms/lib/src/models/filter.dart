enum FilterType { equal, like, gt, lt }

class Filter {
  Filter(this.key, this.value, {this.type = FilterType.like});

  String key;
  FilterType? type;
  String value;

  Map<String, dynamic> toJson() {
    final t = type == FilterType.equal
        ? 'equal'
        : type == FilterType.like
            ? 'equal'
            : type == FilterType.gt
                ? 'equal'
                : 'lt';
    return <String, dynamic>{
      'key': key,
      'type': t,
      'value': value,
    };
  }
}
