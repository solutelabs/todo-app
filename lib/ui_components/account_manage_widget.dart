import 'package:checklist/bloc/account_manage/account_manage_bloc.dart';
import 'package:checklist/bloc/account_manage/bloc.dart';
import 'package:checklist/pages/auth/sign_in_page.dart';
import 'package:shared_code/shared_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class AccountManageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    return BlocProvider<AccountManageBloc>(
      builder: (context) => AccountManageBloc(c<AuthRepository>()),
      child: Builder(
        builder: (BuildContext context) {
          return BlocListener<AccountManageBloc, AccountManageState>(
            listener: (context, state) {
              if (state is LoggedOutState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInPage.routeName,
                  (_) => false,
                );
              }
            },
            child: IconButton(
              onPressed: () async {
                BlocProvider.of<AccountManageBloc>(context).add(OnTapLogout());
              },
              icon: Icon(Icons.power_settings_new),
            ),
          );
        },
      ),
    );
  }
}
