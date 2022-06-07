import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaStore {
  TetaStore(
    this.token,
    this.prjId,
  );

  final String token;
  final int prjId;

  Map<String, String> get headers => <String, String>{
        'authorization': 'Bearer $token',
        'x-teta-prj-id': '$prjId',
      };

  Future<void> productList(final String userToken) async {
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

    TetaCMS.printWarning('list products body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception(
        'list products resulted in ${res.statusCode} ${res.body}',
      );
    }
  }

  Future<void> insert(final TetaProduct product) async {
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
      throw Exception(
        'insert product resulted in ${res.statusCode} ${res.body}',
      );
    }
  }
}
