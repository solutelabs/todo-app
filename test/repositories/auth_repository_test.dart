import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthServices {}

void main() {
  final mockService = MockAuthService();
  final repo = AuthRepository(services: mockService);

  test('First it should try to signin, if success return token', () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenAnswer((_) => Future.value('token'));

    final token = await repo.authenticateAndRetrieveToken(
        email: 'email', password: 'password');

    expect(token, equals('token'));
    verify(mockService.signIn(email: 'email', password: 'password'));
    verifyNoMoreInteractions(mockService);
  });

  test(
      'In case of wrong (but existing) credentials, it should throw invalid credentials exception',
      () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenThrow(InvalidCredentials());

    await expectLater(
        () => repo.authenticateAndRetrieveToken(
            email: 'email', password: 'password'),
        throwsA(predicate((e) => e is InvalidCredentials)));
    verify(mockService.signIn(email: 'email', password: 'password'));
    verifyNoMoreInteractions(mockService);
  });

  test(
      'In case of non existing credentials, it should try to signup and return token',
      () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenThrow(UserNotAvailable());

    when(
      mockService.signUp(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenAnswer((_) => Future.value('token'));

    final token = await repo.authenticateAndRetrieveToken(
      email: 'email',
      password: 'password',
    );

    expect(token, equals('token'));
    verify(mockService.signIn(email: 'email', password: 'password'));
    verify(mockService.signUp(email: 'email', password: 'password'));
    verifyNoMoreInteractions(mockService);
  });
}
