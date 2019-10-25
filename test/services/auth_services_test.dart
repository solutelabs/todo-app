import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDioClient extends Mock implements Dio {}

main() {
  final mockDio = MockDioClient();
  final service = AuthServices(dioClient: mockDio);
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Passing properties should signUp and return id token', () async {
    when(mockDio.post(
      any,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer(
      (_) => Future.value(
        Response(
          data: {
            "idToken": "ABC",
          },
          statusCode: 200,
        ),
      ),
    );

    final response =
        await service.signUp(email: "name@example.con", password: "123");

    expectLater(response, equals("ABC"));
  });

  test('Passing valid credentials should return id token', () async {
    when(mockDio.post(
      any,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenAnswer(
      (_) => Future.value(
        Response(
          data: {
            "idToken": "ABC",
          },
          statusCode: 200,
        ),
      ),
    );

    final response = await service.signIn(
      email: "name@example.con",
      password: "123",
    );

    expectLater(response, equals("ABC"));
  });

  test('Passing wrong credentials should throw InvalidCredentialsException',
      () async {
    when(mockDio.post(
      any,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(
      DioError(
        response: Response(
          data: {
            "error": {
              "code": 400,
              "message": "INVALID_PASSWORD",
              "errors": [
                {
                  "message": "INVALID_PASSWORD",
                  "domain": "global",
                  "reason": "invalid"
                }
              ]
            }
          },
          statusCode: 400,
        ),
      ),
    );

    expectLater(
      () => service.signIn(email: "email", password: "password"),
      throwsA(
        predicate((e) => e is InvalidCredentials),
      ),
    );
  });

  test('Passing non existed credentials should throw UserNotAvailable',
      () async {
    when(mockDio.post(
      any,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(
      DioError(
        response: Response(
          data: {
            "error": {
              "code": 400,
              "message": "EMAIL_NOT_FOUND",
              "errors": [
                {
                  "message": "EMAIL_NOT_FOUND",
                  "domain": "global",
                  "reason": "invalid"
                }
              ]
            }
          },
          statusCode: 400,
        ),
      ),
    );

    expectLater(
      () => service.signIn(email: "email", password: "password"),
      throwsA(
        predicate((e) => e is UserNotAvailable),
      ),
    );
  });

  test("If error doesn't have data, it should rethrow exception", () async {
    when(mockDio.post(
      any,
      data: anyNamed('data'),
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    )).thenThrow(
      DioError(
        response: Response(
          data: null,
          statusCode: 400,
        ),
      ),
    );

    expectLater(
      () => service.signIn(email: "email", password: "password"),
      throwsException,
    );
  });
}
