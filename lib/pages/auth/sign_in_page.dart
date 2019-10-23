import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const routeName = 'signIn';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(),
          TextField(),
          RaisedButton(),
        ],
      ),
    );
  }
}
