import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teta_cms/teta_cms.dart';

void main() {
  if (true) {
    test(
      'Put new collection',
      () async {
        await TetaCMS.instance.client.insertCollection(
          collection: const CollectionObject(
            name: 'Collection 1',
            prjId: 98521,
          ),
        );
      },
    );
  }
  test(
    'Get collections',
    () async {
      final collections =
          await TetaCMS.instance.client.getCollections(prjId: 1);
      final firstCollection = await TetaCMS.instance.client.getCollection(
        prjId: 1,
        id: collections.first.id,
      );
      debugPrint('$firstCollection');
    },
  );
}
