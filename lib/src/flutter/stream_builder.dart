import 'package:flutter/material.dart';

/// A custom StreamBuilder to avoid unwanted calls

class TetaStreamBuilder<T> extends StatefulWidget {
  /// A custom StreamBuilder to avoid unwanted calls

  const TetaStreamBuilder({
    required this.stream,
    required this.builder,
    final Key? key,
  }) : super(key: key);

  /// The stream
  final Stream<T> stream;

  /// The builder
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  @override
  State<TetaStreamBuilder<T>> createState() => _TetaStreamBuilderState<T>();
}

class _TetaStreamBuilderState<T> extends State<TetaStreamBuilder<T>> {
  late Stream<T> _stream;

  @override
  void initState() {
    super.initState();
    _stream = widget.stream;
  }

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder<T>(
      stream: _stream,
      builder: widget.builder,
    );
  }
}
