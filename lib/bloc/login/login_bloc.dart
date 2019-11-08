import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:checklist/bloc/login/bloc.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/utils/string_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:checklist/exceptions/custom_exceptions.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({@required this.authRepository});

  @override
  LoginState get initialState => LoginFormInValid();

  String email = '';
  String password = '';

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is CheckActiveSession) {
      yield* checkActiveSession();
    }

    if (event is EmailEntered) {
      email = event.email;
      yield* validateForm();
    }

    if (event is PasswordEntered) {
      password = event.password;
      yield* validateForm();
    }

    if (event is LoginButtonPressed) {
      yield* signIn();
    }

    if (event is ResetPasswordRequest) {
      if (!isEmailValid(email)) {
        yield ResetPasswordFailed(error: 'Enter Valid Email');
        return;
      }

      try {
        await authRepository.resetPassword(email: email);
        yield ResetPasswordSuccess();
      } on UserNotAvailable catch (_) {
        yield ResetPasswordFailed(
            error:
                'Email is not registered. Kindly enter password and continue to register yourself.');
      } catch (_) {
        yield ResetPasswordFailed(error: 'Failed to send Reset password email');
      }
    }
  }

  Stream<LoginState> checkActiveSession() async* {
    final token = await authRepository.getToken();
    if (token != null) {
      yield LoginLoggedIn();
    }
  }

  Stream<LoginState> validateForm() async* {
    if (isEmailValid(email) && password.isNotEmpty) {
      yield LoginFormValid();
    } else {
      yield LoginFormInValid();
    }
  }

  Stream<LoginState> signIn() async* {
    yield LoginLoading();
    try {
      await authRepository.authenticateAndRetrieveToken(
        email: email,
        password: password,
      );
      yield LoginLoggedIn();
    } on InvalidCredentials catch (_) {
      yield LoginFailed(error: "Invalid Password!");
    } catch (_) {
      yield LoginFailed(error: "Failed to Sign-in!");
    }
    yield LoginFormValid();
  }
}
