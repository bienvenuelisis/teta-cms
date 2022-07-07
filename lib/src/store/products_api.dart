import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStoreProductsApi {
  TetaStoreProductsApi(
    this.productMapper,
    this.getServerRequestHeaders,
    this.dio,
  );

  final ProductMapper productMapper;
  final GetServerRequestHeaders getServerRequestHeaders;
  final Dio dio;

  /// Gets all the products.
  /// The products are taken by the project's shop.
  Future<TetaProductsResponse> all() async {
    try {
      final res = await dio.get<String>(
        '${U.storeProductUrl}list',
        options: Options(
          headers: getServerRequestHeaders.execute(),
        ),
      );

      if (res.statusCode != 200) {
        return TetaProductsResponse(
          error: TetaErrorResponse(
            code: res.statusCode,
            message: res.data,
          ),
        );
      }
      final decodedList = (jsonDecode(res.data!) as List<dynamic>)
          .map((final dynamic e) => e as Map<String, dynamic>)
          .toList(growable: false);

      return TetaProductsResponse(
        data: productMapper.mapProducts(decodedList),
      );
    } catch (e) {
      return TetaProductsResponse(
        error: TetaErrorResponse(
          code: 403,
          message: '$e',
        ),
      );
    }
  }

  /// Gets a single product by id.
  /// The product is selected in the project's shop
  Future<TetaProductResponse> get(final String prodId) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}$prodId',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    TetaCMS.printWarning('list products body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaProductResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaProductResponse(
      data: productMapper
          .mapProduct(json.decode(res.body) as Map<String, dynamic>),
    );
  }

  /// Adds a new product on the shop of the project.
  /// 1 prj = 1 shop.
  /// If everything goes ok it returns {'ok': true}
  Future<TetaResponse> insert(final TetaProduct product) async {
    final uri = Uri.parse(
      U.storeProductUrl,
    );

    final res = await http.post(
      uri,
      headers: getServerRequestHeaders.execute(),
      body: json.encode(
        product.toJson(),
      ),
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

  /// Updates a product by id.
  /// Wants a product object to update all the fields.
  Future<TetaProductResponse> update(final TetaProduct product) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}${product.id}',
    );

    final res = await http.post(
      uri,
      headers: getServerRequestHeaders.execute(),
      body: json.encode(
        product.toJson(),
      ),
    );

    if (res.statusCode != 200) {
      return TetaProductResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaProductResponse(
      data: product,
    );
  }

  /// Deletes a product by id
  Future<TetaResponse> delete(final String prodId) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}$prodId',
    );

    final res = await http.post(
      uri,
      headers: {
        ...getServerRequestHeaders.execute(),
        'content-type': 'application/json',
      },
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
      data: null,
      error: null,
    );
  }
}
