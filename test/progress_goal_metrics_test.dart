import 'package:calora/features/progress/models/progress_goal_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const metrics = ProgressGoalMetrics(
    dailyCalorieTarget: 2000,
    proteinGoalGrams: 120,
    carbohydrateGoalGrams: 250,
    fatGoalGrams: 70,
  );

  test('normalizes daily calories against the calorie target', () {
    expect(metrics.calorieChartValue(1000), 0.5);
    expect(metrics.calorieChartValue(2400), 1);
  });

  test('fills macro meters against their individual goals', () {
    expect(metrics.proteinSegments(60), 4);
    expect(metrics.carbohydrateSegments(125), 4);
    expect(metrics.fatSegments(35), 4);
    expect(metrics.fatSegments(100), 8);
  });

  test('uses a safe calorie fallback and empty macro values without goals', () {
    const withoutGoals = ProgressGoalMetrics();

    expect(withoutGoals.calorieChartValue(1000), 0.5);
    expect(withoutGoals.proteinSegments(80), 0);
  });
}
