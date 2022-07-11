import 'package:flutter/material.dart';
import 'package:teta_cms/teta_cms.dart';

void main() {
  const prjToken = '';
  const prjId = 0;

  TetaCMS.initialize(
    token: prjToken,
    prjId: prjId,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({final Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
            TetaFutureBuilder<TetaResponse<List<dynamic>?, TetaErrorResponse?>>(
          future: TetaCMS.instance.client.query(
            '''
              MATCH name EQ Example;
              IN docs;
            ''',
          ),
          builder: (final c, final snap) {
            if (snap.connectionState == ConnectionState.done) {
              if (snap.data?.error != null) {
                return Text('${snap.data?.error?.message}');
              }
              return ListView.builder(
                itemCount: snap.data?.data?.length ?? 0,
                itemBuilder: (final c, final i) {
                  // ignore: avoid_dynamic_calls
                  return Text('${snap.data?.data?[i]['_name']}');
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
