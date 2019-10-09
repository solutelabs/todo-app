import 'package:checklist/daos/checklist_items_dao.dart';
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

  Stream<List<ChecklistItem>> getItemsForDate({@required DateTime date}) {
    return getItemsInDateRange(startDate: date, endDate: date);
  }

  Stream<List<ChecklistItem>> getItemsInDateRange({
    @required DateTime startDate,
    @required DateTime endDate,
  }) {
    return _dao.getItemsInDateRange(startDate: startDate, endDate: endDate);
  }

  Future<ChecklistItem> insert({
    @required String descritpion,
    DateTime targetDate,
  }) async {
    final id = Uuid().v1();
    final item = ChecklistItem(
      id: id,
      description: descritpion,
      targetDate: targetDate,
    );
    return _dao.insert(item: item);
  }

  Future<ChecklistItem> update({
    @required String id,
    String descritpion,
    DateTime targetDate,
  }) async {
    return _dao.update(
      id: id,
      descritpion: descritpion,
      targetDate: targetDate,
    );
  }

  Future<void> delete({@required String id}) {
    return _dao.delete(id: id);
  }
}
