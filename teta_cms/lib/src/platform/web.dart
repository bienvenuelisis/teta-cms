import 'dart:async';
import 'dart:js';

import 'package:flutter/material.dart';

class CMSPlatform {
  static Future login(
    final String url,
    final BuildContext ctx,
    final Function(String) callback,
  ) async {
    late final JsObject child;
    final completer = Completer<String>();
    Future onParentWindowMessage(final dynamic message) async {
      if (message == null) return;
      if ((message.origin as String).startsWith('https://auth.teta.so')) {
        final data = message.data.toString();
        final token = data.substring(7, data.length - 1);
        callback(token);
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
