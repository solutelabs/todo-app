import 'package:checklist/bloc/login/bloc.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock_dependencies.dart';

void main() {
  LoginBloc loginBloc;
  MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    loginBloc = LoginBloc(
      authRepository: authRepository,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  test(('Initial State'), () {
    expectLater(loginBloc.initialState, LoginFormInValid());
  });

  test('Invalid Inputs should emit LoginFormInvalid()', () {
    final expected = [
      LoginFormInValid(),
    ];

    expectLater(loginBloc, emitsInOrder(expected));

    loginBloc.add(EmailEntered('email'));
  });

  test('Valid Inputs should emit LoginFormValid()', () {
    final expected = [LoginFormInValid(), LoginFormValid()];

    expectLater(loginBloc, emitsInOrder(expected));

    loginBloc.add(EmailEntered('example@email.com'));
    loginBloc.add(PasswordEntered('password'));
  });

  test('Correct id passowrd should emit LoggedIn() state', () {
    final expected = [
      LoginFormInValid(),
      LoginFormValid(),
      LoginLoading(),
      LoginLoggedIn(),
    ];

    when(
      authRepository.authenticateAndRetrieveToken(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) => Future.value('token'));

    expectLater(loginBloc, emitsInOrder(expected));

    loginBloc.add(EmailEntered('example@email.com'));
    loginBloc.add(PasswordEntered('password'));
    loginBloc.add(LoginButtonPressed());
  });

  test(
      'Incorrect id passowrd should emit LoginFailed() state with proper message',
      () {
    final expected = [
      LoginFormInValid(),
      LoginFormValid(),
      LoginLoading(),
      LoginFailed(error: 'Invalid Password!'),
    ];

    when(
      authRepository.authenticateAndRetrieveToken(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(InvalidCredentials());

    expectLater(loginBloc, emitsInOrder(expected));

    loginBloc.add(EmailEntered('example@email.com'));
    loginBloc.add(PasswordEntered('password'));
    loginBloc.add(LoginButtonPressed());
  });

  test('Other error should emit LoginFailed() state with proper message', () {
    final expected = [
      LoginFormInValid(),
      LoginFormValid(),
      LoginLoading(),
      LoginFailed(error: 'Failed to Sign-in!'),
    ];

    when(
      authRepository.authenticateAndRetrieveToken(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(Exception());

    expectLater(loginBloc, emitsInOrder(expected));

    loginBloc.add(EmailEntered('example@email.com'));
    loginBloc.add(PasswordEntered('password'));
    loginBloc.add(LoginButtonPressed());
  });

  test('If Session is active it should emit LoggedIn()', () {
    final expected = [LoginFormInValid(), LoginLoggedIn()];
    when(authRepository.getToken()).thenAnswer((_) => Future.value('token'));
    expectLater(loginBloc, emitsInOrder(expected));
    loginBloc.add(CheckActiveSession());
  });

  test('If Session is not active it should not emit LoggedIn()', () {
    final expected = [LoginFormInValid()];
    when(authRepository.getToken()).thenAnswer((_) => Future.value(null));
    expectLater(loginBloc, emitsInOrder(expected));
    loginBloc.add(CheckActiveSession());
  });
}
