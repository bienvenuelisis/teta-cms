import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/teta_cms.dart';

class TetaAuth {
  TetaAuth(
    this.token,
    this.prjId,
  );
  final String token;
  final int prjId;

  /// This function is cute
  Future<String> signIn({
    final String clientId =
        '492292088461-8kbvq3eh43atb0en8vcqgshsq5ohco58.apps.googleusercontent.com',
    final String clientSecret = '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',
  }) async {
    final res = await http.post(
      Uri.parse('https://auth.teta.so/auth/google'),
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
  ) async {
    final url = await signIn();
    await showDialog<void>(
      context: context,
      builder: (final ctx) => AlertDialog(
        content: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: Text(url),
          ),
        ),
      ),
    );
  }
}
