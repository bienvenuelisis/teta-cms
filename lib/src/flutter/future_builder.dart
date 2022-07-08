import 'package:flutter/material.dart';

/// A custom FutureBuilder to avoid unwanted calls
class TetaFutureBuilder<T> extends StatefulWidget {
  /// A custom FutureBuilder to avoid unwanted calls
  const TetaFutureBuilder({
    required this.future,
    required this.builder,
    final Key? key,
  }) : super(key: key);

  /// The future
  final Future<T> future;

  /// The builder
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  @override
  State<TetaFutureBuilder<T>> createState() => _TetaFutureBuilderState<T>();
}

class _TetaFutureBuilderState<T> extends State<TetaFutureBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    _future = widget.future;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: widget.builder,
    );
  }
}
