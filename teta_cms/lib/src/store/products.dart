import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/models/response.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStoreProducts {
  TetaStoreProducts(
    this.token,
    this.prjId,
  );

  final String token;
  final int prjId;

  Map<String, String> get headers => <String, String>{
        'authorization': 'Bearer $token',
        'x-teta-prj-id': '$prjId',
      };

  /// Gets all the products.
  /// The products are taken by the project's shop.
  Future<TetaResponse> all() async {
    final uri = Uri.parse(
      '${U.storeProductUrl}list',
    );

    final res = await http.get(
      uri,
      headers: {
        ...headers,
        'content-type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse(
      data: json.decode(res.body),
    );
  }

  /// Gets a single product by id.
  /// The product is selected in the project's shop
  Future<TetaResponse> get(final String prodId) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}$prodId',
    );

    final res = await http.get(
      uri,
      headers: {
        ...headers,
        'content-type': 'application/json',
      },
    );

    TetaCMS.printWarning('list products body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse(
      data: json.decode(res.body),
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
      headers: {
        ...headers,
        'content-type': 'application/json',
      },
      body: json.encode(
        product.toJson(),
      ),
    );

    TetaCMS.printWarning('insert product body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse(data: json.encode(res.body));
  }

  /// Updates a product by id.
  /// Wants a product object to update all the fields.
  Future<TetaResponse> update(final TetaProduct product) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}${product.id}',
    );

    final res = await http.post(
      uri,
      headers: {
        ...headers,
        'content-type': 'application/json',
      },
      body: json.encode(
        product.toJson(),
      ),
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse(data: json.encode(res.body));
  }

  /// Deletes a product by id
  Future<TetaResponse> delete(final String prodId) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}$prodId',
    );

    final res = await http.post(
      uri,
      headers: {
        ...headers,
        'content-type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaResponse(data: json.encode(res.body));
  }
}
