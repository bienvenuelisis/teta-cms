import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_windows/webview_windows.dart';

class CMSPlatform {
  static Future login(
    final String url,
    final BuildContext ctx,
    final Function(String) callback,
  ) async {
    final encodedUrl = Uri.encodeFull(url);
    if (await canLaunchUrlString(encodedUrl)) {
      await launchUrlString(
        encodedUrl,
        mode: LaunchMode.externalApplication,
      );
      await callback('');
    }
    //! Follow this:
    /*String url = "https://github.com/login/oauth/authorize" +
                  "?client_id=" +
                  "a5a424aaff18f66eb07a" +
                  "&scope=public_repo%20read:user%20user:email";

              if (await canLaunchUrlString(url)) {
                await launchUrlString(
                  url,
                );

                getLinksStream().listen((link) async {
                  if (link != null) {
                    String code =
                        link.substring(link.indexOf(RegExp('code=')) + 5);
                    print(code);
                    closeInAppWebView();
                  }
                }, cancelOnError: true);
              }*/

    /*
    final windowsController = WebviewController();
    if (UniversalPlatform.isWindows) {
      await windowsController.initialize();
      await windowsController.setUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.71',
      );
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
                  jsContent: const {
                    EmbeddedJsContent(
                      js: "(function()) { window.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.71' } ());",
                    ),
                  },
                  userAgent:
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.71',
                  width: double.maxFinite,
                  height: double.maxFinite,
                  onWebViewCreated: (final controller) {
                    webViewController = controller;
                    webViewController?.loadContent(
                      url,
                      SourceType.url,
                    );
                  },
                  navigationDelegate: (final NavigationRequest request) {
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (final String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (final String url) async {
                    print('Page finished loading: $url');
                    if (url.contains('code') &&
                        url.contains('state') &&
                        url.contains('teta.so')) {
                      final webScraper = WebScraper();
                      if (await webScraper.loadFullURL(url)) {
                        final elements = webScraper.getPageContent();
                        print(elements);
                      }
                      //Navigator.of(ctx, rootNavigator: true).pop(url);
                    }
                  },
                  /*onPageStarted: (final url) async {
                    TetaCMS.printWarning(url);
                    if (url.contains('code') &&
                        url.contains('state') &&
                        url.contains('teta.so')) {}
                    if (url.contains('access_token') &&
                        url.contains('refresh_token')) {
                      Navigator.of(ctx, rootNavigator: true).pop(url);
                    }
                  },*/
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
      final box = await Hive.openBox<dynamic>('Teta Auth');
      await box.put('access_tkn', '');
      await box.put('refresh_tkn', '');
      return true;
    } else {
      return false;
    }*/
  }

  static Future<WebviewPermissionDecision> _onPermissionRequested(
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
