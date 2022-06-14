import 'package:flutter/material.dart';

class TetaFutureBuilder<T> extends StatefulWidget {
  const TetaFutureBuilder({
    required this.future,
    required this.builder,
    final Key? key,
  }) : super(key: key);

  final Future<T> future;
  final Function(BuildContext, AsyncSnapshot<T>) builder;

  @override
  State<FutureBuilder<T>> createState() => _FutureBuilderState<T>();
}

class _FutureBuilderState<T> extends State<FutureBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    if (widget.future != null) {
      _future = widget.future!;
    }
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
