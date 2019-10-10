import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  DateTime startOfWeek(DateTime date) {
    return startOfDay(
      date.subtract(Duration(days: date.weekday - 1)),
    );
  }

  DateTime endOfWeek(DateTime date) {
    return endOfDay(
      date.add(Duration(days: DateTime.daysPerWeek - date.weekday)),
    );
  }

  DateTime startOfMonth(DateTime date) {
    return startOfDay(
      date.subtract(Duration(days: date.day - 1)),
    );
  }

  DateTime endOfMonth(DateTime date) {
    return endOfDay(DateTime(date.year, date.month + 1, 0));
  }

  String formatDate(DateTime dateTime, {String format = 'dd/MM/yyyy'}) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat(format).format(dateTime);
  }
}
