import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_code/shared_code.dart';

import '../mock_dependencies.dart';

void main() {
  final kTokenKey = 'token';
  final kUserIdKey = 'user_id';

  final mockService = MockAuthService();
  final mockStorage = MockLocalStorage();
  final repo = AuthRepository(services: mockService, localStorage: mockStorage);

  test('First it should try to signin', () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenAnswer((_) => Future.value({'idToken': 'token', 'localId': 'id'}));

    await repo.authenticateAndRetrieveToken(
      email: 'email',
      password: 'password',
    );

    verify(mockService.signIn(email: 'email', password: 'password'));
    verify(mockStorage.set(kTokenKey, 'token'));
    verify(mockStorage.set(kUserIdKey, 'id'));
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
    verifyNoMoreInteractions(mockStorage);
    verifyNoMoreInteractions(mockService);
  });

  test('In case of non existing credentials, it should try to signup',
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
    ).thenAnswer((_) => Future.value({'idToken': 'token', 'localId': 'id'}));

    await repo.authenticateAndRetrieveToken(
      email: 'email',
      password: 'password',
    );

    verify(mockService.signIn(email: 'email', password: 'password'));
    verify(mockService.signUp(email: 'email', password: 'password'));
    verify(mockStorage.set(kTokenKey, 'token'));
    verify(mockStorage.set(kUserIdKey, 'id'));
    verifyNoMoreInteractions(mockService);
  });

  test('Save Data', () async {
    await repo.saveUserInfo({'idToken': 'token', 'localId': 'id'});
    verify(mockStorage.set(kTokenKey, 'token'));
    verify(mockStorage.set(kUserIdKey, 'id'));
  });

  test('Retrive token', () async {
    when(mockStorage.get<String>(kTokenKey))
        .thenAnswer((_) => Future.value('token'));
    final token = await repo.getToken();
    expect(token, equals('token'));
    verify(mockStorage.get(kTokenKey));
  });

  test('Retrive userId', () async {
    when(mockStorage.get<String>(kUserIdKey))
        .thenAnswer((_) => Future.value('user'));
    final userId = await repo.getUserId();
    expect(userId, 'user');
    verify(mockStorage.get(kUserIdKey));
  });

  test('Should clear data from local storage when Logount', () async {
    await repo.logout();
    verify(mockStorage.clearData());
  });

  test(
    'Reset password should delegate to service layer with proper args',
    () async {
      await repo.resetPassword(email: 'email');
      verify(mockService.resetPassword(email: 'email'));
    },
  );
}
