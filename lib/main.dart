import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/auth/sign_in_page.dart';
import 'package:checklist/pages/home/home_page.dart';
import 'package:checklist/pages/item_details/item_details_page.dart';
import 'package:checklist/pages/items_list_page.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:checklist/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ChecklistItemsRepository>(
      builder: (_) => ChecklistItemsRepository(
        dao: ChecklistItemsDAO(),
        networkServices: CheckListNetworkServices(
          dioClient: dioInstance,
          authRepository: AuthRepository(
            services: AuthServices(
              dioClient: dioInstance,
            ),
            localStorage: FileBasedStorage(),
          ),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SignInPage.routeName,
        routes: {
          SignInPage.routeName: (_) => SignInPage(),
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
          if (settings.name == ItemDetailsPage.routeName) {
            final itemId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ItemDetailsPage(
                id: itemId,
              ),
            );
          }
          return null;
        },
        theme: ThemeData(fontFamily: 'OpenSans'),
      ),
    );
  }
}
