import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final AuthServices services;

  AuthRepository({@required this.services});

  Future<String> authenticateAndRetrieveToken({
    @required String email,
    @required String password,
  }) async {
    try {
      return services.signIn(email: email, password: password);
    } on UserNotAvailable catch (_) {
      return services.signUp(email: email, password: password);
    }
  }
}
