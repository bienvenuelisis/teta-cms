import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/teta_cms.dart';

/// User utils
class TetaUserUtils {
  /// User utils
  TetaUserUtils(
    this.token,
    this.prjId,
  );

  /// Token of the current prj
  final String token;

  /// Id of the current prj
  final int prjId;

  /// Check if users is logged in
  Future<TetaUser?> get get async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    final accessToken = await box.get('access_tkn') as String?;
    if (accessToken != null) {
      final uri = Uri.parse(
        'https://cms.teta.so:9840/auth/info/$prjId',
      );

      final res = await http.get(
        uri,
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      );

      TetaCMS.printWarning('insertUser body: ${res.body}');

      if (res.statusCode != 200) {
        throw Exception('insertUser resulted in ${res.statusCode} ${res.body}');
      }

      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.tetaAuthGetCurrentUser,
          'Teta Auth: get current user request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: false,
        ),
      );

      final user = TetaUser.fromJson(
        json.decode(res.body) as Map<String, dynamic>? ?? <String, dynamic>{},
      );
      await TetaCMS.instance.analytics.init(userId: user.uid);
      return user;
    }
    return null;
  }

  /// Check if users is logged in
  Future<bool> hasAccessToken() async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    return await box.get('access_tkn') != null;
  }

  /*Future verifyToken() async {
    try {

      // Verify a token
      final jwt = JWT.verify(token, SecretKey(''));

      print('Payload: ${jwt.payload}');
    } on JWTExpiredError {
      print('jwt expired');
    } on JWTError catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }*/
}
