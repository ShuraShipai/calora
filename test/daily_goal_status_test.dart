import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lists every configured goal and its completion state', () {
    final goals = dailyGoalStatuses(
      caloriesEaten: 2000,
      calorieGoal: 2000,
      proteinGrams: 50,
      proteinGoalGrams: 100,
      carbohydratesGrams: 200,
      carbohydratesGoalGrams: 200,
      fatGrams: 40,
      fatGoalGrams: 60,
      waterMillilitres: 2000,
      waterGoalLiters: 2,
      currentWeightKg: 70,
      targetWeightKg: 70,
      wellnessGoal: WellnessGoal.maintainWeight,
    );

    expect(goals.map((goal) => goal.name), <String>[
      'Daily calorie target',
      'Protein target',
      'Carbohydrate target',
      'Fat target',
      'Water target',
      'Weight target',
    ]);
    expect(goals.map((goal) => goal.isCompleted), <bool>[
      true,
      false,
      true,
      false,
      true,
      true,
    ]);
  });
}
