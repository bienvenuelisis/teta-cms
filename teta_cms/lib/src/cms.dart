import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:teta_cms/src/analytics.dart';
import 'package:teta_cms/src/auth.dart';
import 'package:teta_cms/src/client.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/di/injection_container.dart';
import 'package:teta_cms/src/store.dart';
import 'package:teta_cms/teta_cms.dart';
import 'package:universal_platform/universal_platform.dart';

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
  static TetaCMS initialize({
    required final int prjId,
    final String? token,
    final bool? debug,
  }) {
    /*assert(
      !_instance._initialized,
      'This instance is already initialized',
    );*/
    _instance._init(
      token ?? _getToken(),
      prjId,
    );
    TetaCMS.log('***** TetaCMS init completed $_instance');
    return _instance;
  }

  static final TetaCMS _instance = TetaCMS._();

  bool _initialized = false;

  /// The TetaCMS client for this instance
  ///
  /// Throws an error if [TetaCMS.initialize] was not called.
  late TetaClient client;

  /// The TetaRealtime instance
  late TetaRealtime realtime;

  /// The TetaAuth instance
  late TetaAuth auth;

  /// The TetaStore instance
  late TetaStore store;

  /// The TetaStore instance
  late TetaAnalytics analytics;

  /// Dispose the instance to free up resources.
  void dispose() {
    _initialized = false;
  }

  Future<void> _init(
    final String token,
    final int prjId,
  ) async {
    //https://github.com/flutter/flutter/issues/99155#issuecomment-1052023743
    try {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
    } catch (e) {
      //This can throw unimplemented error on some platforms.
      print('Info: $e');
    }
    if (Platform.isAndroid) {
      PathProviderAndroid.registerWith();
    }

    if (Platform.isIOS) {
      PathProviderIOS.registerWith();
    }

    if (!diInitialized) {
      initGetIt();
      diInitialized = true;
    }

    sl
        .get<ServerRequestMetadataStore>()
        .updateMetadata(token: token, prjId: prjId);
    realtime = TetaRealtime(
      token,
      prjId,
    );
    auth = TetaAuth(
      token,
      prjId,
    );
    client = TetaClient(
      token,
      prjId,
    );
    store = sl.get<TetaStore>();

    if (!UniversalPlatform.isWeb && !Hive.isBoxOpen('Teta Auth')) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    _initialized = true;
    analytics = TetaAnalytics(
      token,
      prjId,
    );
  }

  static String _getToken() {
    final box = Hive.box<dynamic>('Teta_CMS');
    return box.get('tkn') as String;
  }

  static void log(final String msg) {
    if (kDebugMode) {
      debugPrint(msg);
    }
  }

  static void printWarning(final String text) => log('\x1B[33m$text\x1B[0m');

  static void printError(final String text) => log('\x1B[31m$text\x1B[0m');

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
