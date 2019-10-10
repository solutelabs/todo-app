class DateTimeUtils {
  DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  DateTime startOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  DateTime endOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day + (DateTime.daysPerWeek - date.weekday),
      23,
      59,
      59,
    );
  }

  DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
}
