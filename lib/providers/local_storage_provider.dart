import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart' as file_storage;

abstract class LocalStorage {
  Future<void> set<T>(String key, T data);

  Future<T> get<T>(String key);

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
  Future<T> get<T>(String key) {
    return Future.value(storage[key]);
  }

  @override
  Future<void> set<T>(String key, T data) {
    storage[key] = data;
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
  Future<T> get<T>(String key) async {
    await _init();
    return fileStorage.getItem(key);
  }

  @override
  Future<void> set<T>(String key, T data) async {
    await _init();
    return fileStorage.setItem(key, data);
  }

  @override
  Future<void> clearData() {
    return fileStorage.clear();
  }
}
