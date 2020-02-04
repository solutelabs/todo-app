import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:shared_code/shared_code.dart';
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

class MockItemsProvider extends Mock implements ItemsProvider {}

class MockCheckListItemsRepository extends Mock
    implements ChecklistItemsRepository {}
