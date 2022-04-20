part of '../index.dart';

class SocketChangeEvent {
  SocketChangeEvent();

  SocketChangeEvent.fromJson(final Map<String, dynamic> json)
      : action = json['action'] as String?,
        collectionId = json['collection_id'] as String?,
        prjId = json['prj_id'] as int?,
        documentId = json['document_id'] as String?,
        timestamp = json['timestamp'] as String?,
        uid = json['uid'] as String;

  String? action;
  String? collectionId;
  int? prjId;
  String? documentId;
  String? timestamp;
  String? uid;
}
