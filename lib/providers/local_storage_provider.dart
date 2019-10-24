abstract class LocalStorage {
  final kTokenKey = 'token';

  Future<void> saveToken(String token);

  Future<String> getToken();
}

class InMemoryStorage extends LocalStorage {
  static final InMemoryStorage _instance = InMemoryStorage._();

  InMemoryStorage._();

  factory InMemoryStorage() {
    return _instance;
  }

  final Map<String, dynamic> storage = {};

  @override
  Future<String> getToken() {
    return Future.value(storage[kTokenKey]);
  }

  @override
  Future<void> saveToken(String token) {
    storage[kTokenKey] = token;
    return null;
  }
}
