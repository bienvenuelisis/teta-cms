import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/platform/web.dart';
import 'package:teta_cms/teta_cms.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:webviewx/webviewx.dart';

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

    final windowsController = WebviewController();
    if (UniversalPlatform.isWindows) {
      await windowsController.initialize();
      await windowsController.loadUrl(url);
      windowsController.url.listen(
        (final url) async {
          TetaCMS.printWarning(url);
          if (url.contains('code') &&
              url.contains('state') &&
              url.contains('teta.so')) {}
          if (url.contains('access_token') && url.contains('refresh_token')) {
            Navigator.of(ctx, rootNavigator: true).pop(url);
          }
        },
      );
    }
    WebViewXController? webViewController;
    final result = await showDialog<String>(
      context: ctx,
      builder: (final ctx) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(ctx).size.width >= 600 ? 400 : double.maxFinite,
          height: MediaQuery.of(ctx).size.width >= 600 ? 400 : double.maxFinite,
          child: Stack(
            children: [
              const Center(
                child: CircularProgressIndicator(),
              ),
              if (UniversalPlatform.isWindows)
                Webview(
                  windowsController,
                  width: double.infinity,
                  height: double.infinity,
                  permissionRequested: (
                    final url,
                    final permissionKind,
                    final isUserInitiated,
                  ) =>
                      _onPermissionRequested(
                    url,
                    permissionKind,
                    isUserInitiated,
                    ctx,
                  ),
                )
              else
                WebViewX(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  onWebViewCreated: (final controller) {
                    webViewController = controller;
                    webViewController?.loadContent(
                      url,
                      SourceType.url,
                    );
                  },
                  onPageStarted: (final url) async {
                    TetaCMS.printWarning(url);
                    if (url.contains('code') &&
                        url.contains('state') &&
                        url.contains('teta.so')) {}
                    if (url.contains('access_token') &&
                        url.contains('refresh_token')) {
                      Navigator.of(ctx, rootNavigator: true).pop(url);
                    }
                  },
                  dartCallBacks: {
                    DartCallback(
                      name: 'abc',
                      callBack: (final dynamic url) {
                        TetaCMS.printWarning('abc: $url');
                      },
                    ),
                  },
                ),
            ],
          ),
        ),
      ),
    );
    TetaCMS.log('result: $result');
    if (result != null) {
      final Box box = await Hive.openBox<Box>('Teta Auth');
      await box.put('access_tkn', '');
      await box.put('refresh_tkn', '');
      return true;
    } else {
      return false;
    }
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
    final String url,
    final WebviewPermissionKind kind,
    final bool isUserInitiated,
    final BuildContext context,
  ) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: context,
      builder: (final BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        title: const Text('WebView permission requested'),
        content: Text("WebView has requested permission '$kind'"),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
