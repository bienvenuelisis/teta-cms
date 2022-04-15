import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:teta_db/src/client.dart';

/// TetaCMS instance.
///
/// It must be initialized before used, otherwise an error is thrown.
///
/// ```dart
/// await TetaCMS.initialize(...)
/// ```
///
/// Use it:
///
/// ```dart
/// final instance = TetaCMS.instance;
/// ```
///
class TetaCMS {
  TetaCMS._();

  /// Gets the current TetaCMS instance.
  ///
  /// An [AssertionError] is thrown if supabase isn't initialized yet.
  /// Call [TetaCMS.initialize] to initialize it.
  static TetaCMS get instance {
    assert(
      _instance._initialized,
      'You must initializze the Teta CMS instance before calling TetaCMS.instance',
    );
    return _instance;
  }

  /// Initialize the current TetaCMS instance
  ///
  /// This must be called only once. If called more than once, an
  /// [AssertionError] is thrown
  static Future<TetaCMS> initialize({
    final String? token,
    final bool? debug,
  }) async {
    assert(
      !_instance._initialized,
      'This instance is already initialized',
    );
    _instance
      .._init(token ?? _getToken())
      .._debugEnable = debug ?? kDebugMode
      ..log('***** TetaCMS init completed $_instance');
    return _instance;
  }

  static final TetaCMS _instance = TetaCMS._();

  bool _initialized = false;

  /// The TetaCMS client for this instance
  ///
  /// Throws an error if [TetaCMS.initialize] was not called.
  late final TetaClient client;
  bool _debugEnable = false;

  /// Dispose the instance to free up resources.
  void dispose() {
    _initialized = false;
  }

  void _init(final String token) {
    client = TetaClient(token);
    _initialized = true;
  }

  static String _getToken() {
    final box = Hive.box<dynamic>('Teta_CMS');
    return box.get('tkn') as String;
  }

  void log(final String msg) {
    if (_debugEnable) {
      debugPrint(msg);
    }
  }
}
