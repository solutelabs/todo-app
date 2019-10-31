import 'package:checklist/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AccountManageViewModel {
  final AuthRepository authRepository;

  AccountManageViewModel({@required this.authRepository});

  Future<void> logout() {
    return authRepository.logout();
  }
}
