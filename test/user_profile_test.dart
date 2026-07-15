import 'package:calora/core/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('user profile decodes persisted onboarding fields', () {
    final profile = UserProfile.fromMap('user-1', <String, dynamic>{
      'name': 'Aanya',
      'email': 'aanya@example.com',
      'isAnonymous': false,
      'onboardingComplete': true,
      'age': 27,
      'heightCm': 165,
      'currentWeightKg': 68,
      'targetWeightKg': 60,
      'activityLevel': 'active',
      'goal': 'loseWeight',
      'unitSystem': 'metric',
      'dailyCalorieTarget': 1840,
    });

    expect(profile.uid, 'user-1');
    expect(profile.onboardingComplete, isTrue);
    expect(profile.onboarding?.activityLevel, ActivityLevel.active);
    expect(profile.onboarding?.goal, WellnessGoal.loseWeight);
    expect(profile.onboarding?.unitSystem, UnitSystem.metric);
  });

  test('blank onboarding details omit unset values', () {
    expect(const OnboardingDetails().toMap(), isEmpty);
  });
}
