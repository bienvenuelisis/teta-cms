part of '../index.dart';

class SocketChangeEvent {
  SocketChangeEvent();

  factory SocketChangeEvent.fromJson(final Map<String, dynamic> json) {
    final instance = SocketChangeEvent()
      ..collection = json['collection'] as String
      ..data = json['data']
      ..method = json['method'] as String
      ..timestamp = json['timestamp'] as int
      ..uid = json['uid'] as String;

    return instance;
  }

  late String collection;
  String? method;
  Object? data;
  int? timestamp;
  String? uid;
}
