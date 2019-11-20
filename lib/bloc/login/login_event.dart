abstract class LoginEvent {
  const LoginEvent();
}

class CheckActiveSession extends LoginEvent {}

class LoginButtonPressed extends LoginEvent {}

class EmailEntered extends LoginEvent {
  final String email;

  const EmailEntered(this.email);
}

class PasswordEntered extends LoginEvent {
  final String password;

  const PasswordEntered(this.password);
}

class ResetPasswordRequest extends LoginEvent {}
