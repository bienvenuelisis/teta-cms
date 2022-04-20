part of '../index.dart';

class RealtimeSubscription {
  RealtimeSubscription(this.uid, this.callback, this.close);

  String uid;
  Function(SocketChangeEvent) callback;

  ///
  /// Call it to close the stream
  ///
  /// Removes the listener from the websocket events
  ///
  Function() close;
}
