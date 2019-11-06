import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:checklist/view_models/account_manage_view_model.dart';
import 'package:checklist/view_models/dashboard_items_view_model.dart';
import 'package:dio/dio.dart';
import 'package:kiwi/kiwi.dart';
import 'package:localstorage/localstorage.dart' as file_storage;

part 'dependencies.g.dart';

abstract class Injector {
  @Register.singleton(Dio)
  //Repositories
  @Register.singleton(ChecklistItemsRepository)
  @Register.factory(AuthRepository)
  //Services
  @Register.factory(AuthServices)
  @Register.factory(CheckListNetworkServices)
  @Register.factory(ChecklistItemsDAO)
  @Register.factory(ItemsProvider)
  //ViewModels
  @Register.factory(DashboardItemsViewModel)
  @Register.factory(AccountManageViewModel)
  void configure();
}

void setup() {
  var injector = _$Injector();

  Container().registerSingleton((c) => BaseOptions());

  Container()
      .registerSingleton((c) => file_storage.LocalStorage('session_data'));

  Container().registerFactory<LocalStorage, FileBasedStorage>(
      (c) => FileBasedStorage(fileStorage: c<file_storage.LocalStorage>()));

  injector.configure();
}
