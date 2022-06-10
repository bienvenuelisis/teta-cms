enum FilterType { equal, like, gt, lt }

class Filter {
  Filter(this.key, this.value, {this.type = FilterType.like});

  String key;
  FilterType? type;
  String value;
  // String orValue; // Made to make an OR filter request

  Map<String, dynamic> toJson() {
    final t = type == FilterType.equal
        ? 'equal'
        : type == FilterType.like
            ? 'like'
            : type == FilterType.gt
                ? 'gt'
                : 'lt';
    return <String, dynamic>{
      'key': key,
      'type': t,
      'value': value,
    };
  }
}
