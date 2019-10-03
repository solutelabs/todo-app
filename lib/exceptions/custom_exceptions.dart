class ItemNotFoundException implements Exception {
  final String itemId;
  ItemNotFoundException(this.itemId);
}

class InvalidUpdateArgumentsException implements Exception {}
