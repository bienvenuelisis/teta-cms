part of '../index.dart';

class TetaRealtime {
  static final instance = _TetaRealtime();
}

class _TetaRealtime {
  socket_io.Socket? _socket;
  List<NoSqlStream> streams = [];

  Future<void> _openSocket() {
    final completer = Completer<void>();

    if (_socket?.connected == true) {
      completer.complete();
      return completer.future;
    }

    final opts = socket_io.OptionBuilder()
        .setPath('/nosql')
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build();

    _socket = socket_io.io(Constants.tetaUrl, opts);

    _socket?.onConnect((final dynamic _) {
      completer.complete();
    });

    _socket?.on('change', (final dynamic data) {
      final event = SocketChangeEvent.fromJson(data as Map<String, dynamic>);

      for (final stream in streams) {
        if (stream.uid == event.uid) stream.callback(event);
      }
    });

    _socket!.connect();

    return completer.future;
  }

  void _closeStream(final String uid) {
    final stream = streams.firstWhere((final stream) => stream.uid == uid);
    streams.remove(stream);

    if (streams.isEmpty) {
      _socket!.close();
      _socket = null;
    }
  }

  /// Creates a websocket connection to the NoSql database
  /// that listens for events of type [action] and
  /// fires [callback] when the event is emitted.
  ///
  /// Returns a `NoSqlStream`
  ///
  Future<NoSqlStream> listen({
    final StreamAction? action,
    final int? projectId,
    final String? collectionId,
    final String? documentId,
    final String? token,
    final Function(SocketChangeEvent)? callback,
  }) async {
    if (_socket == null) await _openSocket();

    if (action == null) throw Exception('action is required');
    if (projectId == null) throw Exception('projectId is required');
    if (collectionId == null) throw Exception('collectionId is required');
    final docId = action.targetDocument ? '*' : documentId;
    if (docId == null) throw Exception('documentId is required');

    final uri = Uri.parse(
      '${Constants.tetaUrl}/stream/listen/${_socket!.id}/$action/$projectId/$collectionId/$docId',
    );

    final res = await http.post(uri, headers: {
      'content-type': 'application/json',
      'authorization': 'Bearer $token',
    });

    if (res.statusCode != 200) {
      throw Exception('Request resulted in ${res.statusCode} - ${res.body}');
    }

    final uid =
        (json.decode(res.body) as Map<String, dynamic>)['uid'] as String;

    final stream = NoSqlStream(uid, callback!, () => _closeStream(uid));
    streams.add(stream);
    return stream;
  }
}
