import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/client.dart';

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
      'You must initialize the Teta CMS instance before calling TetaCMS.instance',
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
    /*assert(
      !_instance._initialized,
      'This instance is already initialized',
    );*/
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

  static Future<String?> getToken() async {
    final box = await Hive.openBox<dynamic>('supabase_authentication');
    final accessToken =
        ((json.decode(box.get('SUPABASE_PERSIST_SESSION_KEY') as String)
                as Map<String, dynamic>)['currentSession']
            as Map<String, dynamic>)['access_token'] as String;
    final refreshToken =
        ((json.decode(box.get('SUPABASE_PERSIST_SESSION_KEY') as String)
                as Map<String, dynamic>)['currentSession']
            as Map<String, dynamic>)['refresh_token'] as String;
    //SUPABASE_PERSIST_SESSION_KEY
    const url = 'https://auth.teta.so/auth';
    final response = await http.post(
      Uri.parse(url),
      headers: {'content-type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          'access_token': accessToken,
          'refresh_token': refreshToken,
        },
      ),
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List<dynamic>;
      final result = list.first as bool;
      final token = list.last as String;
      if (result) {
        return token;
      } else {
        throw Exception('Error putDoc $token');
      }
    } else {
      throw Exception('Error putDoc ${response.statusCode}: ${response.body}');
    }
  }
}
