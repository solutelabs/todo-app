import 'package:checklist/models/list_mode.dart';
import 'package:shared_code/shared_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final utils = ListModeUtils();
  final now = DateTime.now();
  group('Checklist items by Mode', () {
    test("Validate Today's date range", () {
      final dates = utils.getDatesForMode(ListMode.today);
      expect(dates['start_date'], DateTimeUtils().startOfDay(now));
      expect(dates['end_date'], DateTimeUtils().endOfDay(now));
    });

    test("Validate this weeks date range", () {
      final dates = utils.getDatesForMode(ListMode.thisWeek);
      expect(dates['start_date'], DateTimeUtils().startOfWeek(now));
      expect(dates['end_date'], DateTimeUtils().endOfWeek(now));
    });

    test("Validate this months date range", () {
      final dates = utils.getDatesForMode(ListMode.thisMonth);
      expect(dates['start_date'], DateTimeUtils().startOfMonth(now));
      expect(dates['end_date'], DateTimeUtils().endOfMonth(now));
    });
  });

  test('Verify Proper titles', () {
    expect(utils.getTitle(ListMode.all), equals('All'));
    expect(utils.getTitle(ListMode.today), equals('Today'));
    expect(utils.getTitle(ListMode.thisMonth), equals('This Month'));
    expect(utils.getTitle(ListMode.thisWeek), equals('This Week'));
  });
}
