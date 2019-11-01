import 'package:checklist/pages/auth/sign_in_page.dart';
import 'package:checklist/providers/viewmodel_provider.dart';
import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountManageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AccountManageViewModel>(
      builder: (context) => provideAccountManageViewModel(),
      child: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () async {
              await Provider.of<AccountManageViewModel>(context).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInPage.routeName,
                (_) => false,
              );
            },
            icon: Icon(Icons.power_settings_new),
          );
        },
      ),
    );
  }
}
