import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onboarding starts empty and moves through four steps', () {
    final provider = OnboardingProvider(initialName: 'Aanya');

    expect(provider.step, 0);
    expect(provider.activityLevel, isNull);
    expect(provider.goal, isNull);
    expect(provider.unitSystem, isNull);

    provider.next();
    provider.next();
    provider.next();
    provider.next();
    expect(provider.step, OnboardingProvider.totalSteps - 1);

    provider.back();
    expect(provider.step, OnboardingProvider.totalSteps - 2);
  });

  test('onboarding details preserve entered values and selections', () {
    final provider = OnboardingProvider(initialName: 'Aanya')
      ..updateAge('27')
      ..updateHeight('165')
      ..updateCurrentWeight('68')
      ..updateTargetWeight('60')
      ..selectActivity(ActivityLevel.active)
      ..selectGoal(WellnessGoal.improveNutrition)
      ..selectUnitSystem(UnitSystem.imperial);

    expect(provider.details.age, 27);
    expect(provider.details.heightCm, 165);
    expect(provider.details.currentWeightKg, 68);
    expect(provider.details.targetWeightKg, 60);
    expect(provider.details.activityLevel, ActivityLevel.active);
    expect(provider.details.goal, WellnessGoal.improveNutrition);
    expect(provider.details.unitSystem, UnitSystem.imperial);
    expect(provider.details.dailyCalorieTarget, isNull);
  });

  test('adds optional remaining goals in the selected unit system', () {
    final provider = OnboardingProvider()
      ..selectUnitSystem(UnitSystem.imperial)
      ..updateDailyCalorieTarget('2000')
      ..updateProteinGoal('120')
      ..updateCarbohydrateGoal('250')
      ..updateFatGoal('70')
      ..updateWaterGoal('64')
      ..updateWeeklyWeightGoal('1');

    expect(provider.details.dailyCalorieTarget, 2000);
    expect(provider.details.proteinGoalGrams, 120);
    expect(provider.details.carbohydrateGoalGrams, 250);
    expect(provider.details.fatGoalGrams, 70);
    expect(provider.details.waterGoalLiters, closeTo(1.89, 0.01));
    expect(provider.details.weeklyWeightGoalKg, closeTo(0.45, 0.01));
  });
}
