import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final kTokenKey = 'token';
  final kUserIdKey = 'user_id';

  final AuthServices services;
  final LocalStorage localStorage;

  AuthRepository({
    @required this.services,
    @required this.localStorage,
  });

  Future<void> authenticateAndRetrieveToken({
    @required String email,
    @required String password,
  }) async {
    try {
      final data = await services.signIn(email: email, password: password);
      await saveUserInfo(data);
    } on UserNotAvailable catch (_) {
      final data = await services.signUp(email: email, password: password);
      await saveUserInfo(data);
    }
  }

  Future<void> saveUserInfo(Map<String, dynamic> data) async {
    await localStorage.set<String>(kTokenKey, data['idToken']);
    await localStorage.set<String>(kUserIdKey, data['localId']);
  }

  Future<String> getToken() {
    return localStorage.get<String>(kTokenKey);
  }

  Future<String> getUserId() {
    return localStorage.get<String>(kUserIdKey);
  }

  Future<void> logout() {
    return localStorage.clearData();
  }
}
