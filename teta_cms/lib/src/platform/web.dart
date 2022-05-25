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
      if (message == null) return;
      TetaCMS.printWarning('message: $message');
      if ((message.origin as String).startsWith('https://auth.teta.so')) {
        final data = message.data.toString();
        TetaCMS.printWarning('data: $data');

        final token = data.substring(7, data.length - 1);
        TetaCMS.printWarning('result: $token');

        await callback(token);

        //? Do shits with the token here

        child.callMethod('close');
        completer.complete(token);
      }
    }

    context['onmessage'] = onParentWindowMessage;
    final urls = [url];
    child = context.callMethod('open', urls) as JsObject;
  }
}
