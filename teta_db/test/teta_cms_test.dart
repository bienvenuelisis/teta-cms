import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teta_db/teta_db.dart';

void main() {
  if (true) {
    test(
      'Put new collection',
      () async {
        await TetaCMS.instance.insertCollection(
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
      final collections = await TetaCMS.instance.getCollections(prjId: 1);
      final firstCollection = await TetaCMS.instance.getCollection(
        prjId: 1,
        id: collections.first.id,
      );
      debugPrint('$firstCollection');
    },
  );
}
