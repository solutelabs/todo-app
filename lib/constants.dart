import 'dart:convert';

import 'package:flutter/services.dart';

class APIEndPoints {
  static const signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp';

  static const signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';

  static const todoAppBaseUrl = 'https://todoapp-a89de.firebaseio.com';
}

Future<String> firebaseAPIKey() async {
  final configuration =
      await rootBundle.loadString('lib/assets/configuration.json');
  final configurationJson = json.decode(configuration);
  return configurationJson['firebase_key'];
}
