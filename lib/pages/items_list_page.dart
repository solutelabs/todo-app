import 'package:shared_code/shared_code.dart';
import 'package:checklist/pages/home/items_list_view.dart';
import 'package:checklist/pages/item_details/item_details_page.dart';
import 'package:flutter/material.dart';

class ItemsListPage extends StatelessWidget {
  static const routeName = '/itemsList';

  final ListMode listMode;

  const ItemsListPage({
    Key key,
    this.listMode = ListMode.all,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: ItemsListView(
        listMode: listMode,
        onItemSelected: (id) => Navigator.of(context).pushNamed(
          ItemDetailsPage.routeName,
          arguments: id,
        ),
      ),
    );
  }
}
