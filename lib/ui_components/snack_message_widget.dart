import 'dart:async';

import 'package:flutter/material.dart';

class SnackMessageWidget extends StatefulWidget {
  SnackMessageWidget({@required this.messageStream});

  final Stream<String> messageStream;

  @override
  _SnackMessageWidgetState createState() => _SnackMessageWidgetState();
}

class _SnackMessageWidgetState extends State<SnackMessageWidget> {
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription ??= widget.messageStream.listen(_showMessage);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _showMessage(String msg) {
    if (msg == null || msg.isEmpty) {
      return;
    }
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
