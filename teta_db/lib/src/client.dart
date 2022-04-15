import 'package:flutter/material.dart';
import 'package:teta_db/src/constants.dart';
import 'package:teta_db/src/middle.dart';
import 'package:teta_db/teta_db.dart';

class TetaClient {
  TetaClient(this.token);
  final String token;

  Future<List<CollectionObject>> getCollections({
    required final int prjId,
  }) async {
    try {
      final response = await TetaDB.instance.select(
        'collections.prj_id',
        prjId,
        isList: true,
        projection: 'collections.docs',
        token: token,
      ) as List<dynamic>;
      final collections = <CollectionObject>[];
      for (final col in response) {
        collections.add(
          CollectionObject.fromJson(json: col as Map<String, dynamic>),
        );
      }
      return collections;
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  Future<CollectionObject?> getCollection({
    required final int prjId,
    required final String id,
  }) async {
    try {
      final response = await TetaMiddleAPI.instance.getDocsByQuery(
        collection: 'collections',
        query: <String, dynamic>{
          Constants.prjIdKey: prjId,
          Constants.docId: id,
        },
      );
      if (response.isNotEmpty) {
        return CollectionObject.fromJson(
          json: response.first as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  Future<void> insertCollection({
    required final CollectionObject collection,
  }) async {
    try {
      final dynamic response = await TetaMiddleAPI.instance.insertDoc(
        collection: 'collections',
        attributes: collection.toJson(),
      );
      debugPrint('$response');
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateCollection({
    required final CollectionObject collection,
  }) async {
    try {
      final dynamic response = await TetaDB.instance.insert(
        'collections',
        'prj_id',
        collection.prjId,
        <String, dynamic>{
          'name': collection.name,
        },
        token: token,
      );
      debugPrint('$response');
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> deleteCollection({
    required final CollectionObject collection,
  }) async {
    try {
      final response = await TetaDB.instance.delete(
        'collections',
        path: 'collections._id',
        value: collection.id,
        token: token,
      );
      debugPrint('$response');
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<List<dynamic>> getDocs({
    required final String id,
  }) async {
    try {
      final dynamic json = await TetaDB.instance.select(
        'collections._id',
        id,
        projection: 'docs',
        isList: true,
        projectionInclusive: true,
        token: token,
      );

      final docs = ((json as List<dynamic>).first
          as Map<String, dynamic>)['docs'] as List<dynamic>;

      debugPrint('$docs');
      debugPrint('${docs.runtimeType}');

      return docs;
    } catch (e) {
      debugPrint('$e');
      return <dynamic>[];
    }
  }

  Future<void> insertDoc({
    required final CollectionObject collection,
    required final Map<String, dynamic> doc,
  }) async {
    try {
      final response = await TetaDB.instance.insert(
        'collections',
        'collections._id',
        collection.id,
        <String, dynamic>{
          '\$push': {
            'docs': doc,
          },
        },
        token: token,
      );
      debugPrint('insertDoc response: $response');
    } catch (e) {
      debugPrint('error in insertDoc: $e');
    }
  }

  Future<void> updateDoc({
    required final CollectionObject collection,
    required final Map<String, dynamic> doc,
  }) async {
    try {
      final response = await TetaDB.instance.updateDocument(
        collection.id,
        doc['_id'] as String,
        doc,
        token: token,
      );
      debugPrint('insertDoc response: $response');
    } catch (e) {
      debugPrint('error in insertDoc: $e');
    }
  }

  Future<void> deleteDoc({
    required final int prjId,
    required final String docId,
  }) async {
    try {
      // update
      final response = await TetaDB.instance.insert(
        'collections',
        'prj_id',
        prjId,
        <String, dynamic>{
          '\$pull': {
            'docs': {'_id': docId},
          }
        },
        token: token,
      );
      debugPrint('$response');
    } catch (e) {
      debugPrint('$e');
    }
  }
}
