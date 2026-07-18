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
}
