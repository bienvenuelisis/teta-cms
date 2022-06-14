import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/mappers/cart_mapper.dart';
import 'package:teta_cms/src/models/response.dart';
import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStoreCartsApi {
  TetaStoreCartsApi(
    this.cartMapper,
    this.getServerRequestHeaders,
  );

  final CartMapper cartMapper;
  final GetServerRequestHeaders getServerRequestHeaders;

  /// Gets a cart by [userId]
  Future<TetaResponse> get(final String userId) async {
    final uri = Uri.parse(
      '${U.storeCartUrl}$userId',
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
        ),
        data: null,
      );
    }

    return TetaResponse<TetaCart, dynamic>(
      data: cartMapper.mapCart(
        json.decode(res.body) as Map<String, dynamic>,
      ),
      error: null,
    );
  }

  /// Adds the [product] to the cart of the given [userId]
  Future<TetaResponse> insert(
    final String productId,
  ) async {
    final userId = (await TetaCMS.instance.auth.user.get)['uid'] as String?;

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
  Future<TetaResponse> delete(final String userId, final String prodId) async {
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
        data: json.encode(res.body), error: null);
  }
}
