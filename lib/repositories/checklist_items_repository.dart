import 'package:checklist/daos/checklist_items_dao.dart';
import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class ChecklistItemsRepository {
  final ChecklistItemsDAO _dao;

  ChecklistItemsRepository(this._dao);

  void dispose() {
    _dao.dispose();
  }

  Future<ChecklistItem> getItem(String id) {
    return _dao.getItem(id);
  }

  Stream<List<ChecklistItem>> getAllItems() {
    return _dao.getAllItems();
  }

  Stream<List<ChecklistItem>> getUnscheduledItems() {
    return _dao.getUnscheduledItems();
  }

  Stream<List<ChecklistItem>> getItemsInDateRange({
    @required DateTime startDate,
    @required DateTime endDate,
  }) {
    return _dao.getItemsInDateRange(startDate: startDate, endDate: endDate);
  }

  Future<ChecklistItem> insert({
    @required String description,
    DateTime targetDate,
  }) async {
    final id = Uuid().v1();
    final item = ChecklistItem(
      id: id,
      description: description,
      targetDate: targetDate,
      isCompleted: false,
    );
    return _dao.insert(item: item);
  }

  Future<ChecklistItem> update({
    @required String id,
    String descritpion,
    DateTime targetDate,
    bool isCompleted,
  }) async {
    if ((descritpion == null || descritpion.isEmpty) &&
        targetDate == null &&
        isCompleted == null) {
      throw InvalidUpdateArgumentsException();
    }
    final item = await _dao.getItem(id);
    final updatedItem = ChecklistItem(
      id: id,
      description: descritpion ?? item.description,
      targetDate: targetDate ?? item.targetDate,
      isCompleted: isCompleted ?? item.isCompleted,
    );
    await _dao.update(item: updatedItem);
    return updatedItem;
  }

  Future<void> delete({@required String id}) {
    return _dao.delete(id: id);
  }
}
