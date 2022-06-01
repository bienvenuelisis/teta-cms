import 'dart:async';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:teta_cms/teta_cms.dart';

class CMSPlatform {
  static Future login(
    final String url,
    final BuildContext ctx,
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
