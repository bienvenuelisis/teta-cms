part of '../index.dart';

class TetaNoSqlUtils {
  static final instance = _TetaNoSqlUtils();
}

class _TetaNoSqlUtils {
  /// Creates a `path` for `select` function using [collection] and [path].
  ///
  /// [collection] = The collection
  ///
  /// [path] = List of path elements
  ///
  /// Returns the [path] as a `String`
  ///
  String buildPath(final String collection, final List<dynamic> path) {
    return '$collection.${path.join('.')}';
  }

  /// Creates a nested object from [path] assigning [value] to the deeper element
  ///
  /// ### Example:
  ///
  /// [path] = `tests.page.primary.header`
  ///
  /// [value] = `ayaya`
  ///
  /// will result in
  ///
  /// ```json
  /// {
  ///   "page": {
  ///     "primary": {
  ///       "header": "ayaya"
  ///    }
  ///  }
  /// ```
  ///
  /// Returns the [path] as a nested object
  ///
  Map<String, dynamic> pathToObject(final String path, final dynamic value) {
    final arr = path.split('.').sublist(1);
    var currentPath = <String, dynamic>{};
    final result = currentPath;
    for (var i = 0; i < arr.length; i++) {
      currentPath[arr[i]] = <String, dynamic>{};
      currentPath = currentPath[arr[i]] as Map<String, dynamic>;
      if (i == arr.length - 1) currentPath[arr[i]] = value;
    }

    return result;
  }
}
