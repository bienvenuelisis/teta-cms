import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/models/response.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/src/utils.dart';

class TetaStore {
  TetaStore(
    this.getServerRequestHeaders,
      this.products,
  );

  final GetServerRequestHeaders getServerRequestHeaders;

  final TetaStoreProductsApi products;

  /// Gets all the store's transactions
  Future<TetaResponse> transactions(final String userToken) async {
    final uri = Uri.parse(
      '${U.storeUrl}transactions',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ), data: null,
      );
    }

    return TetaResponse<dynamic, dynamic>(
      data: json.decode(res.body), error: null,
    );
  }

  /// Delete a store
  Future<TetaResponse> delete() async {
    final uri = Uri.parse(
      U.storeUrl,
    );

    final res = await http.delete(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ), data: null,
      );
    }

    return TetaResponse<String, dynamic>(data: json.encode(res.body), error: null);
  }

  Future<TetaResponse> setCurrency(final String currency) async {
    final uri = Uri.parse(
      '${U.storeUrl}currency/$currency',
    );

    final res = await http.put(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ), data: null,
      );
    }

    return TetaResponse<String, dynamic>(data: json.encode(res.body), error: null);
  }
}
