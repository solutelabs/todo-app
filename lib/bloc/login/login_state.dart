import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginFormInValid extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFormValid extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoggedIn extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends LoginState {
  final String error;

  const LoginFailed({@required this.error});

  @override
  List<Object> get props => [error];
}
