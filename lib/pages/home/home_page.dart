import 'package:checklist/pages/home/dashboard_tab.dart';
import 'package:checklist/pages/home/items_list_tab.dart';
import 'package:checklist/ui_components/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';

enum _HomePageTabType { dashboard, list }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState(_HomePageTabType.dashboard);
}

class _HomePageState extends State<HomePage> {
  final _tabs = [_HomePageTabType.dashboard, _HomePageTabType.list];
  _HomePageTabType _selectedTab;

  _HomePageState(this._selectedTab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('add_item'),
        child: Icon(Icons.add),
        elevation: 8.0,
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          FABBottomAppBarItem(iconData: Icons.home),
          FABBottomAppBarItem(iconData: Icons.grid_on),
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
      case _HomePageTabType.dashboard:
        title = 'Dashboard';
        break;
      case _HomePageTabType.list:
        title = 'Tasks';
        break;
    }
    return title;
  }

  Widget getBody() {
    Widget bodyWidget;
    switch (_selectedTab) {
      case _HomePageTabType.dashboard:
        bodyWidget = DashboardTab();
        break;
      case _HomePageTabType.list:
        bodyWidget = ItemsListTab();
        break;
    }
    return bodyWidget;
  }
}
