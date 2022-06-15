import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

enum TetaAnalyticsEnum {
  teta,
  auth,
  db,
  store,
  usage,
}

class TetaAnalytics {
  TetaAnalytics(
    this.token,
    this.prjId,
  );
  final String token;
  final int prjId;

  /// Creates a new event
  Future<TetaResponse> insertEvent(
    final TetaAnalyticsEnum type,
    final String name,
    final Map<String, dynamic> properties,
  ) async {
    final uri = Uri.parse(
      '${U.analyticsUrl}events/${EnumToString.convertToString(type)}',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'x-identifier': '$prjId',
      },
      body: json.encode(<String, dynamic>{
        'name': name,
        ...properties,
      }),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse<dynamic, TetaErrorResponse?>(
      data: res.body,
      error: null,
    );
  }

  /// Creates a new event
  Future<TetaResponse> get(
    final TetaAnalyticsEnum group,
    final String name,
    final Map<String, dynamic> properties,
  ) async {
    final uri = Uri.parse(
      '${U.analyticsUrl}events',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'x-identifier': '$prjId',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse<dynamic, TetaErrorResponse?>(
      data: res.body,
      error: null,
    );
  }
}
