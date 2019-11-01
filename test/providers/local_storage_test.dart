import 'package:checklist/providers/local_storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart' as file_storage;
import 'package:mockito/mockito.dart';

class MockFileStorage extends Mock implements file_storage.LocalStorage {}

main() {
  final tokenKey = 'token_key';

  group('In Memory storage', () {
    test('Should save and return value properly', () async {
      await InMemoryStorage().set(tokenKey, 'token');
      final token = await InMemoryStorage().get(tokenKey);
      expectLater(token, equals('token'));
    });

    test('Should return NULL after clear', () async {
      await InMemoryStorage().clearData();
      final token = await InMemoryStorage().get(tokenKey);
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

    test('Set method should call set in storage with proper key', () async {
      await storage.set(tokenKey, 'token');
      verify(mockFileStorage.setItem(tokenKey, 'token'));
    });

    test('Get method should call get in storage with proper key', () async {
      await storage.get(tokenKey);
      verify(mockFileStorage.getItem(tokenKey));
    });

    test('Should clear from LocalStorage when clearData()', () async {
      await storage.clearData();
      verify(mockFileStorage.clear());
    });
  });
}
