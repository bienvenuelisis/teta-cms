import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/platform/index.dart';
import 'package:teta_cms/src/users/settings.dart';
import 'package:teta_cms/teta_cms.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

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

    await _persistentLogin(userToken);
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

  /// Performs login in mobile and web platforms
  Future<bool> signInWithBrowser(
    final BuildContext ctx, {
    required final Function() callback,
    final TetaProvider provider = TetaProvider.google,
  }) async {
    final url = await _signIn(prjId: prjId, provider: provider);
    await CMSPlatform.login(url, ctx, (final userToken) async {
      if (!UniversalPlatform.isWeb) {
        uriLinkStream.listen(
          (final Uri? uri) async {
            if (uri != null) {
              TetaCMS.log('uri:${uri.toString()}');
              if (uri.queryParameters['access_token'] != null &&
                  uri.queryParameters['access_token'] is String) {
                await closeInAppWebView();
                await TetaCMS.instance.auth.insertUser(
                  // ignore: cast_nullable_to_non_nullable
                  uri.queryParameters['access_token'] as String,
                );
                callback();
              }
            }
          },
          onError: (final Object err) {
            throw Exception(r'got err: $err');
          },
        );
      } else {
        await insertUser(userToken);
        callback();
      }
    });

    return true;
  }

  /// Set access_token for persistent login
  Future _persistentLogin(final String token) async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    await box.put('access_tkn', token);
  }

  /// Check if users is logged in
  Future<bool> hasAccessToken() async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    return await box.get('access_tkn') != null;
  }

  Future logout() async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    await box.delete('access_tkn');
  }
}
