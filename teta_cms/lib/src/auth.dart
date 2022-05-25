import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/platform/index.dart';
import 'package:teta_cms/teta_cms.dart';

enum TetaProvider {
  google,
}

class TetaAuth {
  TetaAuth(
    this.token,
    this.prjId,
  );
  final String token;
  final int prjId;

  Future<void> saveCredentials({
    required final int prjId,
    required final TetaAuthCredentials credentials,
  }) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/credentials/$prjId',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: json.encode(
        <String, dynamic>{
          'g_client_id': credentials.g_client_id,
          'g_client_secret': credentials.g_client_secret,
        },
      ),
    );

    TetaCMS.log('saveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('saveCredentials resulted in ${res.statusCode}');
    }
  }

  Future<TetaAuthCredentials> retrieveCredentials({
    required final int prjId,
  }) async {
    final uri = Uri.parse(
      'https://public.teta.so:9840/auth/credentials/google/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.printWarning('retrieveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveCredentials resulted in ${res.statusCode}');
    }

    final map = json.decode(res.body) as Map<String, dynamic>;
    return TetaAuthCredentials(
      g_client_id: map['client_id'] as String?,
      g_client_secret: map['client_secret'] as String?,
    );
  }

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

  /// This function is cute
  Future<String> signIn({
    required final int prjId,
    required final TetaProvider provider,
  }) async {
    TetaCMS.log('signIn');
    final res = await http.post(
      Uri.parse('https://auth.teta.so/auth/google/$prjId'),
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
    final url = await signIn(prjId: prjId, provider: provider);
    TetaCMS.printWarning('Teta Auth return url: $url');

    await CMSPlatform.login(url, insertUser);

    return true;
  }
}
