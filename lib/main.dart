import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'add_item': (_) => AddItemPage(),
      },
    );
  }
}
