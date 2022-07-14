import 'package:teta_cms/teta_cms.dart';

Future<void> insert(final List<String> args) async {
  const collectionId = '0';
  final res = await TetaCMS.instance.client.insertDocument(
    collectionId,
    <String, dynamic>{'name': 'Giulia', 'city': 'Roma'},
  );
}

Future<void> update(final List<String> args) async {
  const collectionId = '0';
  const documentId = '0';
  final res = await TetaCMS.instance.client.updateDocument(
    collectionId,
    documentId,
    <String, dynamic>{'name': 'Alessia', 'city': 'Milano'},
  );
}

Future<void> delete(final List<String> args) async {
  const collectionId = '0';
  const documentId = '0';
  final res = await TetaCMS.instance.client.deleteDocument(
    collectionId,
    documentId,
  );
}

Future<void> createCollection(final List<String> args) async {
  const collectionName = '0';
  final res = await TetaCMS.instance.client.createCollection(
    collectionName,
  );
}

Future<void> updateCollection(final List<String> args) async {
  const collectionId = '0';
  const newName = '0';
  final res = await TetaCMS.instance.client.updateCollection(
    collectionId,
    newName,
    <String, dynamic>{'key': 'value', 'key': 'value'},
  );
}

Future<void> deleteCollection(final List<String> args) async {
  const collectionId = '0';
  final res = await TetaCMS.instance.client.deleteCollection(
    collectionId,
  );
}
