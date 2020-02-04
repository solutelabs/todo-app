import 'package:shared_code/shared_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTimeUtils utils;

  setUp(() {
    utils = DateTimeUtils();
  });

  test(
    'Start of the day DateTime should have Hours/Minute/Seconds components as Zero',
    () {
      final now = DateTime.now();
      final date = utils.startOfDay(now);
      expect(date.year, now.year);
      expect(date.month, now.month);
      expect(date.day, now.day);
      expect(date.hour, equals(0));
      expect(date.minute, equals(0));
      expect(date.second, equals(0));
      expect(date.millisecond, equals(0));
    },
  );

  test(
    'End of the day DateTime should have Hours/Minute/Seconds components as 12/59/59',
    () {
      final now = DateTime.now();
      final date = utils.endOfDay(now);
      expect(date.year, now.year);
      expect(date.month, now.month);
      expect(date.day, now.day);
      expect(date.hour, equals(23));
      expect(date.minute, equals(59));
      expect(date.second, equals(59));
    },
  );

  test('Start of Month', () {
    final date = DateTime(2019, 10, 26, 10, 25);
    final expectedStartOfMonth = DateTime(2019, 10, 1);
    final startOfTheMonth = utils.startOfMonth(date);
    expect(startOfTheMonth, equals(expectedStartOfMonth));
  });

  group('End of Month', () {
    test('Case: 31 day', () {
      final date = DateTime(2019, 10, 26, 10, 25);
      final expectedEndOfMonth = DateTime(2019, 10, 31, 23, 59, 59);
      final startOfTheMonth = utils.endOfMonth(date);
      expect(startOfTheMonth, equals(expectedEndOfMonth));
    });

    test('Case: 30 day', () {
      final date = DateTime(2019, 11, 26, 10, 25);
      final expectedEndOfMonth = DateTime(2019, 11, 30, 23, 59, 59);
      final startOfTheMonth = utils.endOfMonth(date);
      expect(startOfTheMonth, equals(expectedEndOfMonth));
    });

    test('Case: 29 day', () {
      final date = DateTime(2020, 02, 26, 10, 25);
      final expectedEndOfMonth = DateTime(2020, 02, 29, 23, 59, 59);
      final startOfTheMonth = utils.endOfMonth(date);
      expect(startOfTheMonth, equals(expectedEndOfMonth));
    });

    test('Case: 28 day', () {
      final date = DateTime(2019, 02, 26, 10, 25);
      final expectedEndOfMonth = DateTime(2019, 02, 28, 23, 59, 59);
      final startOfTheMonth = utils.endOfMonth(date);
      expect(startOfTheMonth, equals(expectedEndOfMonth));
    });
  });

  group('Format date', () {
    test('Passing NULL DateTime should return NULL String', () {
      final formattedDate = utils.formatDate(null);
      expect(formattedDate, null);
    });

    test(
        'Date should be formatted in dd/MM/yyyy if format is not provided explicitly',
        () {
      final dateTime = DateTime(2019, 10, 17);
      final formattedDate = utils.formatDate(dateTime);
      expect(formattedDate, equals('17/10/2019'));
    });

    test('Date should be formatted in provided explicit format', () {
      final dateTime = DateTime(2019, 10, 17);
      final formattedDate = utils.formatDate(dateTime, format: 'dd/MM');
      expect(formattedDate, equals('17/10'));
    });
  });
}
