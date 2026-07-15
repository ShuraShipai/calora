/// An inclusive-start/exclusive-end period used by the Progress screen.
class ProgressDateRange {
  ProgressDateRange(this.start, this.end)
    : assert(
        !end.isBefore(start),
        'The end of a range cannot precede its start.',
      );

  final DateTime start;
  final DateTime end;

  int get dayCount => end.difference(start).inDays;

  List<DateTime> get days => List<DateTime>.generate(
    dayCount,
    (index) => start.add(Duration(days: index)),
  );

  /// Labels for a seven-day view, such as `Thu` and `Fri`.
  List<String> get weekdayLabels => days.map(_weekdayLabel).toList();

  /// Labels for a single calendar month, such as `1` and `15`.
  List<String> get dayOfMonthLabels =>
      days.map((day) => day.day.toString()).toList();

  /// Unambiguous labels for longer or arbitrary ranges, such as `15 Jul`.
  List<String> get compactDateLabels => days.map(_compactDateLabel).toList();

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

  static String _weekdayLabel(DateTime day) => const <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ][day.weekday - 1];

  static String _compactDateLabel(DateTime day) =>
      '${day.day} ${const <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][day.month - 1]}';
}
