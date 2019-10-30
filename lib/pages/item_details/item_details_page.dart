import 'package:checklist/pages/item_details/item_details_view.dart';
import 'package:flutter/material.dart';

class ItemDetailsPage extends StatelessWidget {
  static const routeName = '/item_details';

  final String id;

  const ItemDetailsPage({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemDetailsView(
        id: id,
      ),
    );
  }
}
