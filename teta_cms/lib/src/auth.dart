import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
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

  /// This function is cute
  Future<String> signIn({
    required final int prjId,
    required final TetaProvider provider,
    final String clientId =
        '492292088461-8kbvq3eh43atb0en8vcqgshsq5ohco58.apps.googleusercontent.com',
    final String clientSecret = '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',
  }) async {
    final res = await http.post(
      Uri.parse('https://auth.teta.so/auth/google/$prjId'),
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          'clientId': clientId,
          'clientSecret': clientSecret,
        },
      ),
    );

    TetaCMS.log(res.body);

    if (res.statusCode != 200) {
      throw Exception('signIn resulted in ${res.statusCode}');
    }

    return res.body;
  }

  Future<bool> signInWithBrowser(
    final BuildContext context,
    final int prjId, {
    final TetaProvider provider = TetaProvider.google,
  }) async {
    final url = await signIn(prjId: prjId, provider: provider);
    TetaCMS.printWarning('Teta Auth return url: $url');
    final windowsController = WebviewController();
    await windowsController.loadUrl(url);
    windowsController.url.listen(
      (final url) {
        TetaCMS.printWarning(url);
        if (url.contains('access_token') && url.contains('refresh_token')) {
          Navigator.of(context, rootNavigator: true).pop(url);
        }
      },
    );
    WebViewXController? webViewController;
    final result = await showDialog<String>(
      context: context,
      builder: (final ctx) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width:
              MediaQuery.of(context).size.width >= 600 ? 400 : double.maxFinite,
          height:
              MediaQuery.of(context).size.width >= 600 ? 400 : double.maxFinite,
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
                    context,
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
                  onPageStarted: (final url) {
                    TetaCMS.printWarning(url);
                    if (url.contains('access_token') &&
                        url.contains('refresh_token')) {
                      Navigator.of(context, rootNavigator: true).pop(url);
                    }
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
