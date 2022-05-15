import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/teta_cms.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:webviewx/webviewx.dart';

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

  Future signInWithBrowser(
    final BuildContext context,
    final int prjId,
  ) async {
    final url = await signIn(prjId: prjId);
    TetaCMS.printWarning('Teta Auth return url: $url');
    final windowsController = WebviewController();
    windowsController.url.listen(
      (final url) {
        TetaCMS.printWarning(url);
        Navigator.of(context, rootNavigator: true).pop(url);
      },
    );
    WebViewXController? webViewController;
    final result = await showDialog<String>(
      context: context,
      builder: (final ctx) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          height: 400,
          child: UniversalPlatform.isWindows
              ? Webview(
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
              : WebViewX(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  onWebViewCreated: (final controller) {
                    webViewController = controller;
                    webViewController?.loadContent(
                      'https://teta.so',
                      SourceType.url,
                    );
                  },
                  onPageStarted: (final url) {
                    TetaCMS.printWarning(url);
                    const x = 0;
                    //Navigator.of(context, rootNavigator: true).pop(url);
                  },
                ),
        ),
      ),
    );
    TetaCMS.log('result: $result');
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
