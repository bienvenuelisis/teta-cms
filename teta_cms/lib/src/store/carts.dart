import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/models/response.dart';
import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStoreCarts {
  TetaStoreCarts(
    this.token,
    this.prjId,
  );

  final String token;
  final int prjId;

  Map<String, String> get headers => <String, String>{
        'authorization': 'Bearer $token',
        'x-teta-prj-id': '$prjId',
      };

  /// Gets a cart by [userId]
  Future<TetaResponse> get(final String userId) async {
    final uri = Uri.parse(
      '${U.storeCartUrl}$userId',
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
      data: TetaCart.fromJson(
        json.decode(res.body) as Map<String, dynamic>,
      ),
    );
  }

  /// Adds the [product] to the cart of the given [userId]
  Future<TetaResponse> insert(
    final String userId,
    final TetaProduct product,
  ) async {
    final uri = Uri.parse(
      '${U.storeCartUrl}$userId/${product.id}',
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

  /// Deletes a product by id
  Future<TetaResponse> delete(final String userId, final String prodId) async {
    final uri = Uri.parse(
      '${U.storeProductUrl}$userId/$prodId',
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
