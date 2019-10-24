import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final AuthServices services;
  final LocalStorage localStorage;

  AuthRepository({
    @required this.services,
    @required this.localStorage,
  });

  Future<String> authenticateAndRetrieveToken({
    @required String email,
    @required String password,
  }) async {
    try {
      final token = await services.signIn(email: email, password: password);
      await saveToken(token);
      return token;
    } on UserNotAvailable catch (_) {
      final token = await services.signUp(email: email, password: password);
      await saveToken(token);
      return token;
    }
  }

  Future<void> saveToken(String token) {
    return localStorage.saveToken(token);
  }

  Future<String> getToken() {
    return localStorage.getToken();
  }
}
