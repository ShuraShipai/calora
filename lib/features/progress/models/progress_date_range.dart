/// An inclusive-start/exclusive-end period used by the Progress screen.
class ProgressDateRange {
  const ProgressDateRange(this.start, this.end);

  final DateTime start;
  final DateTime end;

  int get dayCount => end.difference(start).inDays;

  List<DateTime> get days => List<DateTime>.generate(
    dayCount,
    (index) => start.add(Duration(days: index)),
  );

  static ProgressDateRange day(DateTime now) {
    final today = _startOfDay(now);
    return ProgressDateRange(today, today.add(const Duration(days: 1)));
  }

  static ProgressDateRange week(DateTime now) {
    final today = _startOfDay(now);
    return ProgressDateRange(
      today.subtract(const Duration(days: 6)),
      today.add(const Duration(days: 1)),
    );
  }

  static ProgressDateRange month(DateTime now) {
    final today = _startOfDay(now);
    return ProgressDateRange(
      DateTime(today.year, today.month, 1),
      today.add(const Duration(days: 1)),
    );
  }

  static ProgressDateRange threeMonths(DateTime now) {
    final today = _startOfDay(now);
    return ProgressDateRange(
      DateTime(today.year, today.month - 2, 1),
      today.add(const Duration(days: 1)),
    );
  }

  static DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
