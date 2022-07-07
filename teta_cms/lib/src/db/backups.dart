import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaBackups {
  TetaBackups(
    this.token,
    this.prjId,
  );
  final String token;
  final int prjId;

  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> all() async {
    final uri = Uri.parse('${U.cmsUrl}backup/$prjId/list');

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

  Future<TetaResponse<Uint8List, TetaErrorResponse?>> download(
    final String? backupId,
  ) async {
    if (backupId != null) {
      final uri = Uri.parse('${U.cmsUrl}backup/$prjId/download/$backupId');

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
    return TetaResponse<Uint8List, TetaErrorResponse>(
      data: Uint8List.fromList([]),
      error: TetaErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }

  Future<TetaResponse<void, TetaErrorResponse?>> restore(
    final String? backupId,
  ) async {
    if (backupId != null) {
      final uri = Uri.parse('${U.cmsUrl}backup/$prjId/restore/$backupId');

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
    return TetaResponse<void, TetaErrorResponse>(
      data: null,
      error: TetaErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }
}
