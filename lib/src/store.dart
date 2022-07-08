import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/store/carts_api.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/teta_cms.dart';

/// Teta Store - Control your ecommerce
class TetaStore {
  /// Teta Store - Control your ecommerce
  TetaStore(
    this.getServerRequestHeaders,
    this.products,
    this.cart,
  );

  /// Headers
  final GetServerRequestHeaders getServerRequestHeaders;

  /// Products apis
  final TetaStoreProductsApi products;

  /// Cart apis
  final TetaStoreCartsApi cart;

  /// Gets products of the current cart
  Future<TetaProductsResponse> getCartProducts() async {
    try {
      final cartResponse = await cart.get();
      final cartProducts = <TetaProduct>[];
      for (final element in cartResponse.data!.content) {
        cartProducts.add((await products.get(element.prodId)).data!);
      }
      return TetaProductsResponse(
        data: cartProducts,
      );
    } catch (e) {
      return TetaProductsResponse(
        error: TetaErrorResponse(
          code: 403,
          message: e.toString(),
        ),
      );
    }
  }

  /// Gets all the store's transactions
  Future<TetaResponse> transactions(final String userToken) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}transactions',
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

    return TetaResponse<dynamic, dynamic>(
      data: json.decode(res.body),
      error: null,
    );
  }

  /// Delete a store
  Future<TetaResponse> delete() async {
    final uri = Uri.parse(
      Constants.storeUrl,
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
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }

  /// Sets a new currency
  Future<TetaResponse> setCurrency(final String currency) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}currency/$currency',
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
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }
}
