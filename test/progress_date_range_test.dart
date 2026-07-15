import 'package:calora/features/progress/models/progress_date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 7, 15, 14, 30);

  test('day is today only', () {
    final range = ProgressDateRange.day(now);

    expect(range.start, DateTime(2026, 7, 15));
    expect(range.end, DateTime(2026, 7, 16));
    expect(range.dayCount, 1);
  });

  test('week is the trailing seven whole days including today', () {
    final range = ProgressDateRange.week(now);

    expect(range.start, DateTime(2026, 7, 9));
    expect(range.end, DateTime(2026, 7, 16));
    expect(range.dayCount, 7);
  });

  test('month starts on the first day and ends after today', () {
    final range = ProgressDateRange.month(now);

    expect(range.start, DateTime(2026, 7, 1));
    expect(range.end, DateTime(2026, 7, 16));
  });

  test('three months starts at the first day of the oldest month', () {
    final range = ProgressDateRange.threeMonths(now);

    expect(range.start, DateTime(2026, 5, 1));
    expect(range.end, DateTime(2026, 7, 16));
  });

  test('week labels use weekday abbreviations', () {
    final range = ProgressDateRange.week(now);

    expect(range.weekdayLabels, <String>[
      'Thu',
      'Fri',
      'Sat',
      'Sun',
      'Mon',
      'Tue',
      'Wed',
    ]);
  });

  test('month labels use day numbers', () {
    final range = ProgressDateRange.month(now);

    expect(range.dayOfMonthLabels.first, '1');
    expect(range.dayOfMonthLabels.last, '15');
  });

  test('long-range labels include the month to avoid repeated day numbers', () {
    final range = ProgressDateRange(
      DateTime(2026, 6, 30),
      DateTime(2026, 7, 2),
    );

    expect(range.compactDateLabels, <String>['30 Jun', '1 Jul']);
  });

  test('a range cannot end before it starts', () {
    expect(
      () => ProgressDateRange(DateTime(2026, 7, 16), DateTime(2026, 7, 15)),
      throwsAssertionError,
    );
  });
}
