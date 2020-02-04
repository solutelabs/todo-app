import 'package:meta/meta.dart';
import 'package:shared_code/shared_code.dart';

class ItemsProvider {
  final ChecklistItemsRepository repository;
  final modeUtils = ListModeUtils();

  ItemsProvider({
    @required this.repository,
  });

  Stream<List<ChecklistItem>> watchItems(ListMode mode) {
    Stream<List<ChecklistItem>> stream;
    switch (mode) {
      case ListMode.today:
      case ListMode.thisWeek:
      case ListMode.thisMonth:
        final dates = modeUtils.getDatesForMode(mode);
        stream = repository.getItemsInDateRange(
          startDate: dates['start_date'],
          endDate: dates['end_date'],
        );
        break;
      case ListMode.all:
        stream = repository.getAllItems();
        break;
    }
    return stream;
  }
}
