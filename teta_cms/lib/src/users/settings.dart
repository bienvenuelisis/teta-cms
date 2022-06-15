import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/teta_cms.dart';

class TetaProjectSettings {
  TetaProjectSettings(
    this.token,
    this.prjId,
  );
  final String token;
  final int prjId;

  Future<void> saveCredentials({
    required final int prjId,
    required final TetaAuthCredentials credentials,
  }) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/credentials/$prjId',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: json.encode(
        credentials.toJson(),
      ),
    );

    TetaCMS.log('saveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('saveCredentials resulted in ${res.statusCode}');
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.auth,
        'Teta Auth: save credentials request',
        <String, dynamic>{
          'prj_id': prjId,
          'weight': res.bodyBytes.lengthInBytes,
        },
      ),
    );
  }

  Future<TetaAuthCredentials> retrieveCredentials({
    required final int prjId,
  }) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/credentials/services/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.printWarning('retrieveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveCredentials resulted in ${res.statusCode}');
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.auth,
        'Teta Auth: retrieve credentials request',
        <String, dynamic>{
          'prj_id': prjId,
          'weight': res.bodyBytes.lengthInBytes,
        },
      ),
    );

    final map = json.decode(res.body) as Map<String, dynamic>;
    return TetaAuthCredentials.fromJson(map);
  }
}
