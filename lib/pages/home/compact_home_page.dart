import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/home/dashboard_view.dart';
import 'package:checklist/pages/home/items_list_view.dart';
import 'package:checklist/pages/item_details/item_details_page.dart';
import 'package:checklist/pages/items_list_page.dart';
import 'package:checklist/ui_components/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';

enum HomeTabs { dashboard, list }

class CompactHomePage extends StatefulWidget {
  @override
  _CompactHomePageState createState() =>
      _CompactHomePageState(HomeTabs.dashboard);
}

class _CompactHomePageState extends State<CompactHomePage> {
  final _tabs = [HomeTabs.dashboard, HomeTabs.list];
  HomeTabs _selectedTab;

  _CompactHomePageState(this._selectedTab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AddItemPage.routeName),
        child: Icon(Icons.add),
        elevation: 8.0,
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          FABBottomAppBarItem(iconData: Icons.dashboard),
          FABBottomAppBarItem(iconData: Icons.list),
        ],
        notchedShape: CircularNotchedRectangle(),
        selectedColor: Theme.of(context).primaryColor,
        color: Colors.grey.shade500,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = _tabs[index];
          });
        },
      ),
    );
  }

  String getTitle() {
    String title;
    switch (_selectedTab) {
      case HomeTabs.dashboard:
        title = 'Dashboard';
        break;
      case HomeTabs.list:
        title = 'Tasks';
        break;
    }
    return title;
  }

  Widget getBody() {
    Widget bodyWidget;
    switch (_selectedTab) {
      case HomeTabs.dashboard:
        bodyWidget = DashboardView(
          onModeSelected: (mode) => Navigator.of(context).pushNamed(
            ItemsListPage.routeName,
            arguments: mode,
          ),
        );
        break;
      case HomeTabs.list:
        bodyWidget = ItemsListView(
          onItemSelected: (id) => Navigator.of(context).pushNamed(
            ItemDetailsPage.routeName,
            arguments: id,
          ),
        );
        break;
    }
    return bodyWidget;
  }
}
