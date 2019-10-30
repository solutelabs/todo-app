import 'package:flutter/material.dart';

class ItemDetailsView extends StatelessWidget {
  final String id;

  const ItemDetailsView({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
