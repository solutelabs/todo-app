import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/providers/repository_provider.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:checklist/utils/io_utils.dart';

AuthServices provideAuthService() => AuthServices(dioClient: dioInstance);

CheckListNetworkServices provideCheckListService() => CheckListNetworkServices(
      dioClient: dioInstance,
    );

LocalStorage provideLocalStorage() => FileBasedStorage(
      fileStorage: localStorage,
    );

ChecklistItemsDAO provideCheckListDao() => ChecklistItemsDAO();

ItemsProvider provideItemsProvider() => ItemsProvider(
      repository: provideCheckListItemsRepository(),
    );
