import 'package:checklist/models/list_mode.dart';
import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/home/home_page.dart';
import 'package:checklist/pages/items_list_page.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checklist/daos/checklist_items_dao.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ChecklistItemsRepository>(
      builder: (_) => ChecklistItemsRepository(ChecklistItemsDAO()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => HomePage(),
          AddItemPage.routeName: (_) => AddItemPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == ItemsListPage.routeName) {
            final listMode = settings.arguments as ListMode;
            return MaterialPageRoute(
              builder: (_) => ItemsListPage(listMode: listMode),
            );
          }
          return null;
        },
        theme: ThemeData(fontFamily: 'OpenSans'),
      ),
    );
  }
}
