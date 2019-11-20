import 'package:equatable/equatable.dart';

abstract class AccountManageState extends Equatable {
  const AccountManageState();
}

class LoggedInState extends AccountManageState {
  @override
  List<Object> get props => [];
}

class LoggedOutState extends AccountManageState {
  @override
  List<Object> get props => [];
}
