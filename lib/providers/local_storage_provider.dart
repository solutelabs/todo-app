import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart' as file_storage;

abstract class LocalStorage {
  final kTokenKey = 'token';
  final kUserIdKey = 'user_id';

  Future<void> saveToken(String token);

  Future<String> getToken();

  Future<void> saveUserId(String userId);

  Future<String> getUserId();

  Future<void> clearData();
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

  @override
  Future<void> clearData() {
    storage.clear();
    return null;
  }
}

class FileBasedStorage extends LocalStorage {
  final file_storage.LocalStorage fileStorage;

  FileBasedStorage({@required this.fileStorage});

  Future<void> _init() async {
    await fileStorage.ready;
  }

  @override
  Future<String> getToken() async {
    await _init();
    return fileStorage.getItem(kTokenKey);
  }

  @override
  Future<String> getUserId() async {
    await _init();
    return fileStorage.getItem(kUserIdKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _init();
    return fileStorage.setItem(kTokenKey, token);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _init();
    return fileStorage.setItem(kUserIdKey, userId);
  }

  @override
  Future<void> clearData() {
    return fileStorage.clear();
  }
}
