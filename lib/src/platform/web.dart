// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:teta_cms/teta_cms.dart';
import 'package:universal_html/js.dart';

/// Use login with providers on different devices
class CMSPlatform {
  /// Use login with providers on different devices
  static Future login(
    final String url,
    final Function(String) callback,
  ) async {
    late final JsObject child;
    final completer = Completer<String>();
    Future onParentWindowMessage(final dynamic message) async {
      TetaCMS.log('message');
      if (message == null) return;
      if ((message.origin as String).startsWith('https://auth.teta.so')) {
        TetaCMS.log(message.data.toString());
        final token = message.data.toString();
        await callback(token);
        child.callMethod('close');
        completer.complete(token);
        return token;
      }
    }

    context['onmessage'] = onParentWindowMessage;
    final urls = [url];
    child = context.callMethod('open', urls) as JsObject;
  }
}
