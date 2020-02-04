import 'package:shared_code/shared_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final Dio dioClient;
  final String firebaseApiKey;

  AuthServices({
    @required this.dioClient,
    @required this.firebaseApiKey,
  });

  Future<Map<String, dynamic>> signUp({
    @required String email,
    @required String password,
  }) async {
    final response = await _authRequest(
      url: APIEndPoints.signUpUrl,
      email: email,
      password: password,
    );

    return response.data;
  }

  Future<Map<String, dynamic>> signIn({
    @required String email,
    @required String password,
  }) async {
    try {
      final response = await _authRequest(
        url: APIEndPoints.signInUrl,
        email: email,
        password: password,
      );

      return response.data;
    } on DioError catch (err) {
      if (err.response == null || err.response.data == null) {
        rethrow;
      }

      final response = err.response.data;
      if (IndexWalker(response)["error"]["message"].value ==
          "INVALID_PASSWORD") {
        throw InvalidCredentials();
      }

      if (IndexWalker(response)["error"]["message"].value ==
          "EMAIL_NOT_FOUND") {
        throw UserNotAvailable();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Response> _authRequest({
    String url,
    String email,
    String password,
  }) async {
    return dioClient.post(
      url,
      queryParameters: {'key': firebaseApiKey},
      options: Options(
        contentType: 'application/json',
      ),
      data: {"email": email, "password": password, "returnSecureToken": true},
    );
  }

  Future<void> resetPassword({
    @required String email,
  }) async {
    try {
      await dioClient.post(
        APIEndPoints.resetPasswordUrl,
        queryParameters: {'key': firebaseApiKey},
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          "email": email,
          "requestType": "PASSWORD_RESET",
        },
      );
    } on DioError catch (err) {
      if (err.response == null || err.response.data == null) {
        rethrow;
      }
      if (IndexWalker(err.response.data)["error"]["message"].value ==
          "EMAIL_NOT_FOUND") {
        throw UserNotAvailable();
      }
    } catch (_) {
      rethrow;
    }
  }
}
