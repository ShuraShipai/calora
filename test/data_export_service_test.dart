import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/features/profile/services/data_export_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports each named goal with a completion tick', () {
    final csv = ShareDataExportService().csvFor(
      diaryEntries: const [],
      waterEntries: const [],
      weightEntries: const [],
      dailyGoals: const <DailyGoalStatus>[
        DailyGoalStatus(name: 'Daily calorie target', isCompleted: true),
        DailyGoalStatus(name: 'Water target', isCompleted: false),
      ],
    );

    expect(csv, contains('goal_name,goal_complete'));
    expect(csv, contains('"Daily calorie target","✓"'));
    expect(csv, contains('"Water target",""'));
  });
}
