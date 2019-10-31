import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

class ItemDetailsViewModel {
  final String itemId;
  final ChecklistItemsRepository repository;

  final title = BehaviorSubject<String>();
  final date = BehaviorSubject<String>();

  ItemDetailsViewModel({
    @required this.itemId,
    @required this.repository,
  }) {
    _init();
  }

  void dispose() {
    title.close();
    date.close();
  }

  Future<void> _init() async {
    final item = await repository.getItem(itemId);
    if (item != null) {
      title.add(item.description);
      date.add(DateTimeUtils().formatDate(item.targetDate));
    }
  }
}
