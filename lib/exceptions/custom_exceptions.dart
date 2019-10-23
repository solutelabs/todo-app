class ItemNotFoundException implements Exception {
  final String itemId;

  ItemNotFoundException(this.itemId);
}

class InvalidUpdateArgumentsException implements Exception {}

class ItemAlreadyExist implements Exception {}

class InvalidCredentials implements Exception {}

class UserNotAvailable implements Exception {}
