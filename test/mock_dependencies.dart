import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:checklist/services/checklist_network_services.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart' as file_storage;
import 'package:mockito/mockito.dart';

class MockFileStorage extends Mock implements file_storage.LocalStorage {}

class MockAuthService extends Mock implements AuthServices {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockDao extends Mock implements ChecklistItemsDAO {}

class MockNetworkService extends Mock implements CheckListNetworkServices {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDioClient extends Mock implements Dio {}

class MockCheckListItemsRepository extends Mock
    implements ChecklistItemsRepository {}
