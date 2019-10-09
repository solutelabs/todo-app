import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/models/checklist_item.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ChecklistItemsDAO {
  final _items = BehaviorSubject<List<ChecklistItem>>.seeded([]);

  void dispose() {
    _items.close();
  }

  Future<ChecklistItem> getItem(String id) async {
    final index = _getItemIndex(id: id);
    return _items.value[index];
  }

  Stream<List<ChecklistItem>> getItemsForDate({@required DateTime date}) {
    return getItemsInDateRange(startDate: date, endDate: date);
  }

  Stream<List<ChecklistItem>> getItemsInDateRange({
    @required DateTime startDate,
    @required DateTime endDate,
  }) {
    return _items.map(
      (list) => list
          .where((i) => i.targetDate != null)
          .where((i) =>
              i.targetDate.millisecondsSinceEpoch >=
              startDate.millisecondsSinceEpoch)
          .where((i) =>
              i.targetDate.millisecondsSinceEpoch <=
              endDate.millisecondsSinceEpoch)
          .toList(),
    );
  }

  Future<ChecklistItem> insert({@required ChecklistItem item}) async {
    final list = _items.value;
    list.add(item);
    _items.add(list);
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
    final items = _items.value;
    final item = items[index];
    final updatedItem = ChecklistItem(
      id: id,
      description: descritpion ?? item.description,
      targetDate: targetDate ?? item.targetDate,
    );
    items[index] = updatedItem;
    _items.add(items);
    return updatedItem;
  }

  Future<void> delete({@required String id}) async {
    final list = _items.value;
    list.removeWhere((item) => item.id == id);
    return _items.add(list);
  }

  int _getItemIndex({@required id}) {
    final index = _items.value.indexWhere((item) => item.id == id);
    if (index == null) {
      throw ItemNotFoundException(id);
    }
    return index;
  }
}
