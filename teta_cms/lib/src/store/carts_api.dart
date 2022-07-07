import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/mappers/cart_mapper.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStoreCartsApi {
  TetaStoreCartsApi(
    this.cartMapper,
    this.getServerRequestHeaders,
    this.dio,
  );

  final CartMapper cartMapper;
  final GetServerRequestHeaders getServerRequestHeaders;
  final Dio dio;

  /// Gets a cart by [userId]
  Future<TetaCartResponse> get() async {
    final cmsUserId = (await TetaCMS.instance.auth.user.get)?.uid ?? '';

    final uri = Uri.parse(
      '${U.storeCartUrl}$cmsUserId',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaCartResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaCartResponse(
      data: cartMapper.mapCart(
        json.decode(res.body) as Map<String, dynamic>,
      ),
    );
  }

  /// Adds the [product] to the cart of the given [userId]
  Future<TetaResponse> insert(
    final String productId,
  ) async {
    final userId = (await TetaCMS.instance.auth.user.get)?.uid;

    final uri = Uri.parse(
      '${U.storeCartUrl}$userId/$productId',
    );

    final res = await http.post(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    TetaCMS.printWarning('insert product body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }

  /// Deletes a product by id
  Future<TetaResponse> delete(final String prodId) async {
    final userId = (await TetaCMS.instance.auth.user.get)?.uid;

    final uri = Uri.parse(
      '${U.storeProductUrl}$userId/$prodId',
    );

    final res = await http.post(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }

  Future<TetaPaymentIntentResponse> getPaymentIntent() async {
    final userId = (await TetaCMS.instance.auth.user.get)?.uid;

    try {
      final res = await dio.post<String>(
        '${U.storeCartUrl}$userId/buy',
        options: Options(
          headers: getServerRequestHeaders.execute(),
        ),
      );

      if (200 != res.statusCode) {
        return TetaPaymentIntentResponse(
          error: TetaErrorResponse(
            code: res.statusCode,
            message: res.data,
          ),
        );
      }

      return TetaPaymentIntentResponse(
        data: (jsonDecode(res.data!) as Map<String, dynamic>)['key'] as String,
      );
    } catch (e) {
      return TetaPaymentIntentResponse(
        error: TetaErrorResponse(message: e.toString(), code: 403),
      );
    }
  }
}
