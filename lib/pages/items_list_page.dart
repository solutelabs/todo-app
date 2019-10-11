import 'package:checklist/models/list_mode.dart';
import 'package:checklist/pages/home/items_list_view.dart';
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
      ),
    );
  }
}
