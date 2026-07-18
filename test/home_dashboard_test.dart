import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('macro meters fill proportionally to their saved goals', () {
    const dashboard = HomeDashboard(
      calorieGoal: 2000,
      caloriesEaten: 0,
      proteinGrams: 50,
      proteinGoalGrams: 100,
      carbohydratesGrams: 150,
      carbohydratesGoalGrams: 200,
      fatGrams: 100,
      fatGoalGrams: 50,
      waterMillilitres: 0,
      meals: <HomeMealType, HomeMealSummary>{},
    );

    expect(
      dashboard.meterSegmentsFor(
        dashboard.proteinGrams,
        dashboard.proteinGoalGrams,
      ),
      4,
    );
    expect(
      dashboard.meterSegmentsFor(
        dashboard.carbohydratesGrams,
        dashboard.carbohydratesGoalGrams,
      ),
      6,
    );
    expect(
      dashboard.meterSegmentsFor(dashboard.fatGrams, dashboard.fatGoalGrams),
      8,
    );
  });

  test('recognizes when the daily calorie target is reached', () {
    final base = HomeDashboard.empty(calorieGoal: 2000);
    final reached = HomeDashboard(
      calorieGoal: 2000,
      caloriesEaten: 2000,
      proteinGrams: 0,
      proteinGoalGrams: 0,
      carbohydratesGrams: 0,
      carbohydratesGoalGrams: 0,
      fatGrams: 0,
      fatGoalGrams: 0,
      waterMillilitres: 0,
      meals: base.meals,
    );

    expect(base.hasReachedCalorieGoal, isFalse);
    expect(reached.hasReachedCalorieGoal, isTrue);
  });

  test('recognizes each reached macro target', () {
    const dashboard = HomeDashboard(
      calorieGoal: 0,
      caloriesEaten: 0,
      proteinGrams: 100,
      proteinGoalGrams: 100,
      carbohydratesGrams: 201,
      carbohydratesGoalGrams: 200,
      fatGrams: 70,
      fatGoalGrams: 70,
      waterMillilitres: 0,
      meals: <HomeMealType, HomeMealSummary>{},
    );

    expect(dashboard.hasReachedProteinGoal, isTrue);
    expect(dashboard.hasReachedCarbohydrateGoal, isTrue);
    expect(dashboard.hasReachedFatGoal, isTrue);
  });
}
