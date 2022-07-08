import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/teta_cms.dart';

/// Teta Analytics is our service to track events in an OLAP DB
class TetaAnalytics {
  ///
  TetaAnalytics(
    this.token,
    this.prjId,
  ) {
    init();
  }

  /// Token of the current prj
  final String token;

  /// Id of the current prj
  final int prjId;

  /// Detected id of the logged user
  String? _currentUserId;

  /// Initialize the logged user id
  Future init({final String? userId}) async {
    _currentUserId = userId ?? (await TetaCMS.instance.auth.user.get)?.uid;
  }

  /// Creates a new event
  Future<TetaResponse> insertEvent(
    final TetaAnalyticsType type,
    final String description,
    final Map<String, dynamic> properties, {
    required final bool isUserIdPreferableIfExists,
  }) async {
    final uri = Uri.parse(
      '${Constants.analyticsUrl}events/add/${EnumToString.convertToString(type)}',
    );

    final res = await http.post(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
        'x-identifier': '$prjId',
      },
      body: json.encode(<String, dynamic>{
        'description': description,
        'prj_id': prjId,
        if (isUserIdPreferableIfExists && _currentUserId != null)
          'user_id': _currentUserId,
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
  Future<TetaResponse<List<dynamic>, TetaErrorResponse?>> get(
    final String ayayaQuery,
  ) async {
    final uri = Uri.parse(
      '${Constants.analyticsUrl}events/aya',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'x-identifier': '$prjId',
      },
      body: ayayaQuery,
    );

    if (res.statusCode != 200) {
      return TetaResponse<List<dynamic>, TetaErrorResponse>(
        data: <dynamic>[],
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    if ((json.decode(res.body) as List<dynamic>?)?.isEmpty ?? true) {
      return TetaResponse<List<dynamic>, TetaErrorResponse?>(
        data: <dynamic>[],
        error: null,
      );
    } else {
      return TetaResponse<List<dynamic>, TetaErrorResponse?>(
        data: ((json.decode(res.body) as List<dynamic>?)?.first
                as Map<String, dynamic>?)?['data'] as List<dynamic>? ??
            <dynamic>[],
        error: null,
      );
    }
  }
}
