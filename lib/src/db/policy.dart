import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/teta_cms.dart';

/// Control all the policies in a project
class TetaPolicies {
  /// Control all the policies in a project
  TetaPolicies(
    this.token,
    this.prjId,
  );

  /// Token of the current prj
  final String token;

  /// Id of the current prj
  final int prjId;

  /// Get all policies
  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> all(
    final String collId,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}backup/$prjId/list');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.log('get backups: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<List<dynamic>?, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    await TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.backupsList,
      'Teta CMS: backups request',
      <String, dynamic>{
        'weight': res.bodyBytes.lengthInBytes,
      },
      isUserIdPreferableIfExists: false,
    );

    final map = json.decode(res.body) as List<dynamic>;
    final backups =
        (map.first as Map<String, dynamic>)['paths'] as List<dynamic>;

    return TetaResponse<List<dynamic>, TetaErrorResponse?>(
      data: backups,
      error: null,
    );
  }

  /// Insert a new policy
  Future<TetaResponse<Uint8List, TetaErrorResponse?>> insert(
    final String collId,
    final String key,
    final String value,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}backup/$prjId/download');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.log('get backup: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<Uint8List, TetaErrorResponse>(
        data: Uint8List.fromList([]),
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    await TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.backupsList,
      'Teta CMS: download backup request',
      <String, dynamic>{},
      isUserIdPreferableIfExists: false,
    );

    return TetaResponse<Uint8List, TetaErrorResponse?>(
      data: res.bodyBytes,
      error: null,
    );
  }

  /// Deletes a new policy
  Future<TetaResponse<void, TetaErrorResponse?>> delete(
    final String policyId,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}backup/$prjId/restore');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 202) {
      return TetaResponse<void, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    await TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.backupsList,
      'Teta CMS: restore backup request',
      <String, dynamic>{},
      isUserIdPreferableIfExists: false,
    );

    return TetaResponse<void, TetaErrorResponse?>(
      data: null,
      error: null,
    );
  }
}
