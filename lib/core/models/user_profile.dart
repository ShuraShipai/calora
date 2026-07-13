enum ActivityLevel { sedentary, lightlyActive, active, veryActive }

enum WellnessGoal {
  loseWeight,
  maintainWeight,
  gainWeight,
  improveNutrition,
  buildHealthyHabits,
}

enum UnitSystem { metric, imperial }

class OnboardingDetails {
  const OnboardingDetails({
    this.age,
    this.heightCm,
    this.currentWeightKg,
    this.targetWeightKg,
    this.activityLevel,
    this.goal,
    this.unitSystem = UnitSystem.metric,
    this.dailyCalorieTarget = 1840,
  });

  final int? age;
  final double? heightCm;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final ActivityLevel? activityLevel;
  final WellnessGoal? goal;
  final UnitSystem unitSystem;
  final int dailyCalorieTarget;

  Map<String, Object?> toMap() => <String, Object?>{
    'age': age,
    'heightCm': heightCm,
    'currentWeightKg': currentWeightKg,
    'targetWeightKg': targetWeightKg,
    'activityLevel': activityLevel?.name,
    'goal': goal?.name,
    'unitSystem': unitSystem.name,
    'dailyCalorieTarget': dailyCalorieTarget,
  };
}

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    required this.isAnonymous,
    required this.onboardingComplete,
    this.email,
    this.onboarding,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    final activity = _enumByName(ActivityLevel.values, data['activityLevel']);
    final goal = _enumByName(WellnessGoal.values, data['goal']);
    final unit =
        _enumByName(UnitSystem.values, data['unitSystem']) ?? UnitSystem.metric;
    final hasOnboardingData =
        data['age'] != null ||
        data['heightCm'] != null ||
        data['currentWeightKg'] != null ||
        data['targetWeightKg'] != null ||
        activity != null ||
        goal != null;

    return UserProfile(
      uid: uid,
      email: data['email'] as String?,
      name: (data['name'] as String?)?.trim() ?? '',
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      onboarding: hasOnboardingData
          ? OnboardingDetails(
              age: (data['age'] as num?)?.toInt(),
              heightCm: (data['heightCm'] as num?)?.toDouble(),
              currentWeightKg: (data['currentWeightKg'] as num?)?.toDouble(),
              targetWeightKg: (data['targetWeightKg'] as num?)?.toDouble(),
              activityLevel: activity,
              goal: goal,
              unitSystem: unit,
              dailyCalorieTarget:
                  (data['dailyCalorieTarget'] as num?)?.toInt() ?? 1840,
            )
          : null,
    );
  }

  final String uid;
  final String? email;
  final String name;
  final bool isAnonymous;
  final bool onboardingComplete;
  final OnboardingDetails? onboarding;

  UserProfile copyWith({
    String? name,
    bool? onboardingComplete,
    OnboardingDetails? onboarding,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      isAnonymous: isAnonymous,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      onboarding: onboarding ?? this.onboarding,
    );
  }
}

T? _enumByName<T extends Enum>(Iterable<T> values, Object? name) {
  if (name is! String) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
