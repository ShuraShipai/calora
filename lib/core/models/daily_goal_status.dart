import 'package:calora/core/models/user_profile.dart';

/// A configured goal and whether its current progress has completed it.
class DailyGoalStatus {
  const DailyGoalStatus({required this.name, required this.isCompleted});

  final String name;
  final bool isCompleted;
}

/// Builds the same goal checklist for the Home screen and exported data.
List<DailyGoalStatus> dailyGoalStatuses({
  required int caloriesEaten,
  required int calorieGoal,
  required int proteinGrams,
  required int proteinGoalGrams,
  required int carbohydratesGrams,
  required int carbohydratesGoalGrams,
  required int fatGrams,
  required int fatGoalGrams,
  required int waterMillilitres,
  required double? waterGoalLiters,
  required double? currentWeightKg,
  required double? targetWeightKg,
  required WellnessGoal? wellnessGoal,
}) => <DailyGoalStatus>[
  if (calorieGoal > 0)
    DailyGoalStatus(
      name: 'Daily calorie target',
      isCompleted: caloriesEaten >= calorieGoal,
    ),
  if (proteinGoalGrams > 0)
    DailyGoalStatus(
      name: 'Protein target',
      isCompleted: proteinGrams >= proteinGoalGrams,
    ),
  if (carbohydratesGoalGrams > 0)
    DailyGoalStatus(
      name: 'Carbohydrate target',
      isCompleted: carbohydratesGrams >= carbohydratesGoalGrams,
    ),
  if (fatGoalGrams > 0)
    DailyGoalStatus(name: 'Fat target', isCompleted: fatGrams >= fatGoalGrams),
  if (waterGoalLiters != null && waterGoalLiters > 0)
    DailyGoalStatus(
      name: 'Water target',
      isCompleted: waterMillilitres >= (waterGoalLiters * 1000).round(),
    ),
  if (currentWeightKg != null &&
      targetWeightKg != null &&
      wellnessGoal != null &&
      _supportsWeightTarget(wellnessGoal))
    DailyGoalStatus(
      name: 'Weight target',
      isCompleted: _hasReachedWeightGoal(
        currentWeightKg: currentWeightKg,
        targetWeightKg: targetWeightKg,
        wellnessGoal: wellnessGoal,
      ),
    ),
];

bool _supportsWeightTarget(WellnessGoal goal) => switch (goal) {
  WellnessGoal.loseWeight ||
  WellnessGoal.maintainWeight ||
  WellnessGoal.gainWeight => true,
  WellnessGoal.improveNutrition || WellnessGoal.buildHealthyHabits => false,
};

bool _hasReachedWeightGoal({
  required double currentWeightKg,
  required double targetWeightKg,
  required WellnessGoal wellnessGoal,
}) => switch (wellnessGoal) {
  WellnessGoal.loseWeight => currentWeightKg <= targetWeightKg,
  WellnessGoal.maintainWeight =>
    (currentWeightKg - targetWeightKg).abs() <= 0.1,
  WellnessGoal.gainWeight => currentWeightKg >= targetWeightKg,
  WellnessGoal.improveNutrition || WellnessGoal.buildHealthyHabits => false,
};
