import 'package:checklist/pages/auth/sign_in_page.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/utils/io_utils.dart';
import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountManageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AccountManageViewModel>(
      builder: (context) => AccountManageViewModel(
        authRepository: AuthRepository(
          services: AuthServices(
            dioClient: dioInstance,
          ),
          localStorage: FileBasedStorage(
            fileStorage: localStorage,
          ),
        ),
      ),
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
