import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'onboarding starts with design defaults and moves through four steps',
    () {
      final provider = OnboardingProvider(initialName: 'Aanya');

      expect(provider.step, 0);
      expect(provider.activityLevel, ActivityLevel.sedentary);
      expect(provider.goal, WellnessGoal.loseWeight);
      expect(provider.unitSystem, UnitSystem.metric);

      provider.next();
      provider.next();
      provider.next();
      provider.next();
      expect(provider.step, OnboardingProvider.totalSteps - 1);

      provider.back();
      expect(provider.step, OnboardingProvider.totalSteps - 2);
    },
  );

  test('onboarding details preserve entered values and selections', () {
    final provider = OnboardingProvider(initialName: 'Aanya')
      ..age = '27'
      ..height = '165'
      ..currentWeight = '68'
      ..targetWeight = '60'
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
    expect(provider.details.dailyCalorieTarget, 1840);
  });
}
