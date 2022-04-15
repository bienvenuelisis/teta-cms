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

    _socket = socket_io.io(_baseUrl, opts);

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
  }

  /// Creates a websocket connection to the NoSql database
  /// that listens for events in [path] with value [value] and
  /// fires [callback] when the event is emitted.
  ///
  /// ### Tip:
  /// You can use `buildPath` from `TetaNoSqlUtils` to create your path.
  ///
  /// Returns a `NoSqlStream`
  ///
  Future<NoSqlStream> stream(
    final String path,
    final dynamic value,
    final Function(SocketChangeEvent) callback,
  ) async {
    if (_socket == null) await _openSocket();

    final collection = path.split('.').first;

    final body = TetaNoSqlUtils.instance.pathToObject(path, value);

    final uri = Uri.parse('$_baseUrl/realtime/$collection/${_socket!.id}');
    final res = await http.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Request resulted in ${res.statusCode} - ${res.body}');
    }

    final uid =
        (json.decode(res.body) as Map<String, dynamic>)['uid'] as String;

    final stream = NoSqlStream(uid, callback, () => _closeStream(uid));
    streams.add(stream);
    return stream;
  }
}
