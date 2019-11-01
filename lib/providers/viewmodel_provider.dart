import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/repository_provider.dart';
import 'package:checklist/providers/services_provider.dart';
import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:checklist/view_models/add_item_view_model.dart';
import 'package:checklist/view_models/dashboard_items_view_model.dart';
import 'package:checklist/view_models/item_details_view_model.dart';
import 'package:checklist/view_models/list_items_view_model.dart';
import 'package:checklist/view_models/sign_in_view_model.dart';

SignInViewModel provideSignInViewModel() => SignInViewModel(
      authRepository: provideAuthRepository(),
    );

ListItemsViewModel provideListItemsViewModel(ListMode listMode) =>
    ListItemsViewModel(
      itemsProvider: provideItemsProvider(),
      mode: listMode,
    );

ItemDetailsViewModel provideItemDetailsViewModel(String itemId) =>
    ItemDetailsViewModel(
      itemId: itemId,
      repository: provideCheckListItemsRepository(),
    );

DashboardItemsViewModel provideDashboardItemsViewModel() =>
    DashboardItemsViewModel(
      itemsProvider: provideItemsProvider(),
    );

AddItemViewModel provideAddItemsViewModel() => AddItemViewModel(
      repository: provideCheckListItemsRepository(),
    );

AccountManageViewModel provideAccountManageViewModel() =>
    AccountManageViewModel(
      authRepository: provideAuthRepository(),
    );
