import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/home/dashboard_view.dart';
import 'package:checklist/pages/home/items_list_view.dart';
import 'package:checklist/pages/items_list_page.dart';
import 'package:checklist/ui_components/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget with UITraitsMixin {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final traits = deriveWidthTrait(context);
    Widget widget;
    switch (traits) {
      case UITrait.compact:
        widget = CompactHomePage();
        break;
      case UITrait.regular:
        widget = RegularHomePage();
        break;
    }
    return widget;
  }
}

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
        bodyWidget = ItemsListView();
        break;
    }
    return bodyWidget;
  }
}

class RegularHomePage extends StatefulWidget {
  @override
  _RegularHomePageState createState() => _RegularHomePageState();
}

class _RegularHomePageState extends State<RegularHomePage> {
  ListMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = ListMode.all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: 160,
            child: DashboardView(
              onModeSelected: (mode) async {
                setState(() {
                  _currentMode = mode;
                  debugPrint(_currentMode.toString());
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: ItemsListView(
              listMode: _currentMode,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.75,
                child: AddItemPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
