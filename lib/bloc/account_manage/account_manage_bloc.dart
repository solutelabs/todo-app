import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_code/shared_code.dart';
import './bloc.dart';

class AccountManageBloc extends Bloc<AccountManageEvent, AccountManageState> {
  final AuthRepository authRepository;

  AccountManageBloc(this.authRepository);

  @override
  AccountManageState get initialState => LoggedInState();

  @override
  Stream<AccountManageState> mapEventToState(
    AccountManageEvent event,
  ) async* {
    if (event is OnTapLogout) {
      await authRepository.logout();
      yield LoggedOutState();
    }
  }
}
