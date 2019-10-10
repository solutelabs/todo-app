import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ListItemsViewModel {
  final ChecklistItemsRepository repository;
  final datetimeUtils = DateTimeUtils();

  BehaviorSubject<ListMode> currentMode;
  final items = BehaviorSubject<List<ChecklistItem>>.seeded([]);

  final _subscriptions = CompositeSubscription();

  ListItemsViewModel({
    @required this.repository,
    @required ListMode mode,
  }) {
    currentMode = BehaviorSubject<ListMode>.seeded(mode);

    _subscriptions.add(
      currentMode.switchMap(onModeChanged).listen(
            items.add,
            onError: (err) => debugPrint(err.toString()),
          ),
    );
  }

  void dispose() {
    currentMode.close();
    items.close();
    _subscriptions.dispose();
  }

  Stream<List<ChecklistItem>> onModeChanged(ListMode newMode) {
    Stream<List<ChecklistItem>> stream;
    switch (newMode) {
      case ListMode.today:
      case ListMode.thisWeek:
      case ListMode.thisMonth:
        final dates = getDatesForMode(newMode);
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

  Map<String, DateTime> getDatesForMode(ListMode mode) {
    final Map<String, DateTime> dates = {};
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    switch (mode) {
      case ListMode.today:
        startDate = datetimeUtils.startOfDay(now);
        endDate = datetimeUtils.endOfDay(now);
        break;
      case ListMode.thisWeek:
        startDate = datetimeUtils.startOfWeek(now);
        endDate = datetimeUtils.endOfWeek(now);
        break;
      case ListMode.thisMonth:
        startDate = datetimeUtils.startOfMonth(now);
        endDate = datetimeUtils.endOfMonth(now);
        break;
      default:
        break;
    }
    if (startDate != null) {
      dates['start_date'] = startDate;
    }
    if (endDate != null) {
      dates['end_date'] = endDate;
    }
    return dates;
  }
}
