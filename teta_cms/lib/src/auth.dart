import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/platform/index.dart';
import 'package:teta_cms/src/users/users.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaAuth {
  TetaAuth(
    this.token,
    this.prjId,
  ) {
    project = TetaProjectSettings(token, prjId);
  }
  final String token;
  final int prjId;
  late TetaProjectSettings project;

  Future<void> insertUser(final String userToken) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/users/$prjId',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: json.encode(
        <String, dynamic>{
          'token': userToken,
        },
      ),
    );

    TetaCMS.printWarning('insertUser body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('insertUser resulted in ${res.statusCode} ${res.body}');
    }
  }

  Future<List<dynamic>> retrieveUsers({
    required final int prjId,
  }) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/users/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.printWarning('retrieveUsers body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveUsers resulted in ${res.statusCode}');
    }

    final list = json.decode(res.body) as List<dynamic>;
    TetaCMS.log('retrieveUsers list: $list');
    final users =
        (list.first as Map<String, dynamic>)['users'] as List<dynamic>;
    TetaCMS.log('retrieveUsers users: $users');
    return users;
  }

  /// Returns auth url from specific provider
  Future<String> _signIn({
    required final int prjId,
    required final TetaProvider provider,
  }) async {
    TetaCMS.log('signIn');
    final param = provider == TetaProvider.google ? 'google' : 'github';
    final res = await http.post(
      Uri.parse('https://auth.teta.so/auth/$param/$prjId'),
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );

    TetaCMS.log(res.body);

    if (res.statusCode != 200) {
      throw Exception('signIn resulted in ${res.statusCode}');
    }

    return res.body;
  }

  Future<bool> signInWithBrowser(
    final BuildContext ctx,
    final int prjId, {
    final TetaProvider provider = TetaProvider.google,
  }) async {
    final url = await _signIn(prjId: prjId, provider: provider);
    TetaCMS.printWarning('Teta Auth return url: $url');

    await CMSPlatform.login(url, ctx, insertUser);

    return true;
  }
}
