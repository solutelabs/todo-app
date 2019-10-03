import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChecklistItemsRepository {
  final List<ChecklistItem> _items = [];
  final uuid = Uuid();

  Future<ChecklistItem> insert({
    @required String descritpion,
    DateTime targetDate,
  }) async {
    final id = uuid.v1();
    final item = ChecklistItem(
      id: id,
      description: descritpion,
      targetDate: targetDate,
    );
    _items.add(item);
    return item;
  }

  Future<ChecklistItem> update({
    @required String id,
    String descritpion,
    DateTime targetDate,
  }) async {
    if ((descritpion == null || descritpion.isEmpty) && targetDate == null) {
      throw InvalidUpdateArgumentsException();
    }
    final index = _getItemIndex(id: id);
    final item = _items[index];
    final updatedItem = ChecklistItem(
      id: id,
      description: descritpion ?? item.description,
      targetDate: targetDate ?? item.targetDate,
    );
    _items[index] = updatedItem;
    return updatedItem;
  }

  Future<void> delete({@required String id}) async {
    return _items.removeWhere((item) => item.id == id);
  }

  int _getItemIndex({@required id}) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == null) {
      throw ItemNotFoundException(id);
    }
    return index;
  }
}
