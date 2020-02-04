import 'package:checklist/models/list_mode.dart';
import 'package:shared_code/src/utils/datetime_utils.dart';

class ListModeUtils {
  final datetimeUtils = DateTimeUtils();

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

  String getTitle(ListMode mode) {
    String title;
    switch (mode) {
      case ListMode.today:
        title = 'Today';
        break;
      case ListMode.thisWeek:
        title = 'This Week';
        break;
      case ListMode.thisMonth:
        title = 'This Month';
        break;
      case ListMode.all:
        title = 'All';
        break;
    }
    return title;
  }
}
