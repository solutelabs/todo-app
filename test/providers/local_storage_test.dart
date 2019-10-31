import 'package:checklist/providers/local_storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart' as file_storage;
import 'package:mockito/mockito.dart';

class MockFileStorage extends Mock implements file_storage.LocalStorage {}

main() {
  group('In Memory storage', () {
    test('Should return saved token, even by new instance', () async {
      await InMemoryStorage().saveToken('token');
      final token = await InMemoryStorage().getToken();
      expectLater(token, equals('token'));
    });

    test('Should return saved userId, even by new instance', () async {
      await InMemoryStorage().saveUserId('user_id');
      final userId = await InMemoryStorage().getUserId();
      expectLater(userId, equals('user_id'));
    });

    test('Should return NULL after clear', () async {
      await InMemoryStorage().clearData();
      final token = await InMemoryStorage().getToken();
      expectLater(token, isNull);
    });
  });

  group('FileBased storage', () {
    FileBasedStorage storage;
    MockFileStorage mockFileStorage;

    setUp(() {
      mockFileStorage = MockFileStorage();
      storage = FileBasedStorage(
        fileStorage: mockFileStorage,
      );
    });

    test('Save token should save to LocalStorage with proper Key and Value',
        () async {
      await storage.saveToken('token');
      verify(mockFileStorage.setItem('token', 'token'));
    });

    test('Save userId should save to LocalStorage with proper Key and Value',
        () async {
      await storage.saveUserId('id');
      verify(mockFileStorage.setItem('user_id', 'id'));
    });

    test('Get userId should get from LocalStorage with proper Key', () async {
      await storage.getUserId();
      verify(mockFileStorage.getItem('user_id'));
    });

    test('Get token should get from LocalStorage with proper Key', () async {
      await storage.getToken();
      verify(mockFileStorage.getItem('token'));
    });

    test('Should clear from LocalStorage when clearData()', () async {
      await storage.clearData();
      verify(mockFileStorage.clear());
    });
  });
}
