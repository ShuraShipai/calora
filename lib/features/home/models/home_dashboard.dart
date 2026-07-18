enum HomeMealType { breakfast, lunch, dinner, snacks }

class HomeMealSummary {
  const HomeMealSummary({required this.itemCount, required this.calories});

  factory HomeMealSummary.fromMap(Map<String, dynamic>? data) {
    return HomeMealSummary(
      itemCount: (data?['itemCount'] as num?)?.toInt() ?? 0,
      calories: (data?['calories'] as num?)?.toInt() ?? 0,
    );
  }

  final int itemCount;
  final int calories;

  bool get isEmpty => itemCount == 0;
}

class HomeDashboard {
  const HomeDashboard({
    required this.calorieGoal,
    required this.caloriesEaten,
    required this.proteinGrams,
    required this.proteinGoalGrams,
    required this.carbohydratesGrams,
    required this.carbohydratesGoalGrams,
    required this.fatGrams,
    required this.fatGoalGrams,
    required this.waterMillilitres,
    required this.meals,
  });

  factory HomeDashboard.empty({int calorieGoal = 0}) => HomeDashboard(
    calorieGoal: calorieGoal,
    caloriesEaten: 0,
    proteinGrams: 0,
    proteinGoalGrams: 0,
    carbohydratesGrams: 0,
    carbohydratesGoalGrams: 0,
    fatGrams: 0,
    fatGoalGrams: 0,
    waterMillilitres: 0,
    meals: Map<HomeMealType, HomeMealSummary>.unmodifiable(
      <HomeMealType, HomeMealSummary>{
        for (final type in HomeMealType.values)
          type: const HomeMealSummary(itemCount: 0, calories: 0),
      },
    ),
  );

  factory HomeDashboard.fromMap(
    Map<String, dynamic> data, {
    required int calorieGoal,
  }) {
    final rawMeals = data['meals'] as Map<String, dynamic>?;
    return HomeDashboard(
      calorieGoal: calorieGoal,
      caloriesEaten: (data['caloriesEaten'] as num?)?.toInt() ?? 0,
      proteinGrams: (data['proteinGrams'] as num?)?.toInt() ?? 0,
      proteinGoalGrams: (data['proteinGoalGrams'] as num?)?.toInt() ?? 0,
      carbohydratesGrams: (data['carbohydratesGrams'] as num?)?.toInt() ?? 0,
      carbohydratesGoalGrams:
          (data['carbohydratesGoalGrams'] as num?)?.toInt() ?? 0,
      fatGrams: (data['fatGrams'] as num?)?.toInt() ?? 0,
      fatGoalGrams: (data['fatGoalGrams'] as num?)?.toInt() ?? 0,
      waterMillilitres: (data['waterMillilitres'] as num?)?.toInt() ?? 0,
      meals: Map<HomeMealType, HomeMealSummary>.unmodifiable(
        <HomeMealType, HomeMealSummary>{
          for (final type in HomeMealType.values)
            type: HomeMealSummary.fromMap(
              rawMeals?[type.name] as Map<String, dynamic>?,
            ),
        },
      ),
    );
  }

  final int calorieGoal;
  final int caloriesEaten;
  final int proteinGrams;
  final int proteinGoalGrams;
  final int carbohydratesGrams;
  final int carbohydratesGoalGrams;
  final int fatGrams;
  final int fatGoalGrams;
  final int waterMillilitres;
  final Map<HomeMealType, HomeMealSummary> meals;

  int get caloriesRemaining =>
      (calorieGoal - caloriesEaten).clamp(0, calorieGoal);

  double get calorieProgress =>
      calorieGoal == 0 ? 0 : (caloriesEaten / calorieGoal).clamp(0, 1);

  bool get hasReachedCalorieGoal =>
      calorieGoal > 0 && caloriesEaten >= calorieGoal;

  bool get hasReachedProteinGoal =>
      proteinGoalGrams > 0 && proteinGrams >= proteinGoalGrams;

  bool get hasReachedCarbohydrateGoal =>
      carbohydratesGoalGrams > 0 &&
      carbohydratesGrams >= carbohydratesGoalGrams;

  bool get hasReachedFatGoal => fatGoalGrams > 0 && fatGrams >= fatGoalGrams;

  HomeMealSummary mealFor(HomeMealType type) => meals[type]!;

  int meterSegmentsFor(int value, int goal) {
    if (goal == 0) return 0;
    return ((value / goal).clamp(0, 1) * 8).round();
  }
}
