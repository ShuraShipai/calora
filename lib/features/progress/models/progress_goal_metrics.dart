class ProgressGoalMetrics {
  const ProgressGoalMetrics({
    this.dailyCalorieTarget,
    this.proteinGoalGrams,
    this.carbohydrateGoalGrams,
    this.fatGoalGrams,
  });

  static const int fallbackDailyCalorieTarget = 2000;

  final int? dailyCalorieTarget;
  final int? proteinGoalGrams;
  final int? carbohydrateGoalGrams;
  final int? fatGoalGrams;

  double calorieChartValue(int calories) =>
      _ratio(calories, _effectiveDailyCalorieTarget);

  int proteinSegments(int averageGrams) =>
      _segments(averageGrams, proteinGoalGrams);

  int carbohydrateSegments(int averageGrams) =>
      _segments(averageGrams, carbohydrateGoalGrams);

  int fatSegments(int averageGrams) => _segments(averageGrams, fatGoalGrams);

  int get _effectiveDailyCalorieTarget =>
      dailyCalorieTarget != null && dailyCalorieTarget! > 0
      ? dailyCalorieTarget!
      : fallbackDailyCalorieTarget;

  double _ratio(int value, int? goal) {
    if (goal == null || goal <= 0) return 0;
    return (value / goal).clamp(0, 1).toDouble();
  }

  int _segments(int value, int? goal) => (_ratio(value, goal) * 8).round();
}
