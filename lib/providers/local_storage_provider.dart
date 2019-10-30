abstract class LocalStorage {
  final kTokenKey = 'token';
  final kUserIdKey = 'user_id';

  Future<void> saveToken(String token);

  Future<String> getToken();

  Future<void> saveUserId(String userId);

  Future<String> getUserId();
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

  @override
  Future<String> getUserId() {
    return Future.value(storage[kUserIdKey]);
  }

  @override
  Future<void> saveUserId(String userId) {
    storage[kUserIdKey] = userId;
    return null;
  }
}
