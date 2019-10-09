import 'package:checklist/ui_components/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
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
        onTabSelected: (index) => null,
      ),
    );
  }
}
