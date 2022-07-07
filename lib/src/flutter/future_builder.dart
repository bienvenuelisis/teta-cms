import 'package:flutter/material.dart';

class TetaFutureBuilder<T> extends StatefulWidget {
  const TetaFutureBuilder({
    required this.future,
    required this.builder,
    final Key? key,
  }) : super(key: key);

  final Future<T> future;
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
