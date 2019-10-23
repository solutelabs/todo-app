import 'package:checklist/constants.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final Dio dioClient;

  AuthServices({@required this.dioClient});

  Future<String> signUp({
    @required String email,
    @required String password,
  }) async {
    final response = await _authRequest(
      url: APIEndPoints.signUpUrl,
      email: email,
      password: password,
    );

    debugPrint(response.data['idToken']);
    return response.data['idToken'];
  }

  Future<String> signIn({
    @required String email,
    @required String password,
  }) async {
    try {
      final response = await _authRequest(
        url: APIEndPoints.signInUrl,
        email: email,
        password: password,
      );

      debugPrint(response.data['idToken']);
      return response.data['idToken'];
    } on DioError catch (err) {
      final response = err.response.data;
      if (response["error"]["message"] == "INVALID_PASSWORD") {
        throw InvalidCredentials();
      }

      if (response["error"]["message"] == "EMAIL_NOT_FOUND") {
        throw UserNotAvailable();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Response> _authRequest({
    String url,
    String email,
    String password,
  }) async {
    final key = await firebaseAPIKey();
    return dioClient.post(
      url,
      queryParameters: {'key': key},
      options: Options(
        contentType: 'application/json',
      ),
      data: {"email": email, "password": password, "returnSecureToken": true},
    );
  }
}
