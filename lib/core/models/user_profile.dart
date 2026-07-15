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
    this.unitSystem,
    this.dailyCalorieTarget,
    this.proteinGoalGrams,
    this.carbohydrateGoalGrams,
    this.fatGoalGrams,
    this.waterGoalLiters,
    this.weeklyWeightGoalKg,
  });

  final int? age;
  final double? heightCm;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final ActivityLevel? activityLevel;
  final WellnessGoal? goal;
  final UnitSystem? unitSystem;
  final int? dailyCalorieTarget;
  final int? proteinGoalGrams;
  final int? carbohydrateGoalGrams;
  final int? fatGoalGrams;
  final double? waterGoalLiters;
  final double? weeklyWeightGoalKg;

  Map<String, Object?> toMap() => <String, Object?>{
    if (age != null) 'age': age,
    if (heightCm != null) 'heightCm': heightCm,
    if (currentWeightKg != null) 'currentWeightKg': currentWeightKg,
    if (targetWeightKg != null) 'targetWeightKg': targetWeightKg,
    if (activityLevel != null) 'activityLevel': activityLevel!.name,
    if (goal != null) 'goal': goal!.name,
    if (unitSystem != null) 'unitSystem': unitSystem!.name,
    if (dailyCalorieTarget != null) 'dailyCalorieTarget': dailyCalorieTarget,
    if (proteinGoalGrams != null) 'proteinGoalGrams': proteinGoalGrams,
    if (carbohydrateGoalGrams != null)
      'carbohydrateGoalGrams': carbohydrateGoalGrams,
    if (fatGoalGrams != null) 'fatGoalGrams': fatGoalGrams,
    if (waterGoalLiters != null) 'waterGoalLiters': waterGoalLiters,
    if (weeklyWeightGoalKg != null) 'weeklyWeightGoalKg': weeklyWeightGoalKg,
  };

  OnboardingDetails copyWith({
    int? age,
    double? heightCm,
    double? currentWeightKg,
    double? targetWeightKg,
    ActivityLevel? activityLevel,
    WellnessGoal? goal,
    UnitSystem? unitSystem,
    int? dailyCalorieTarget,
    int? proteinGoalGrams,
    int? carbohydrateGoalGrams,
    int? fatGoalGrams,
    double? waterGoalLiters,
    double? weeklyWeightGoalKg,
  }) {
    return OnboardingDetails(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      unitSystem: unitSystem ?? this.unitSystem,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinGoalGrams: proteinGoalGrams ?? this.proteinGoalGrams,
      carbohydrateGoalGrams:
          carbohydrateGoalGrams ?? this.carbohydrateGoalGrams,
      fatGoalGrams: fatGoalGrams ?? this.fatGoalGrams,
      waterGoalLiters: waterGoalLiters ?? this.waterGoalLiters,
      weeklyWeightGoalKg: weeklyWeightGoalKg ?? this.weeklyWeightGoalKg,
    );
  }
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
    final unit = _enumByName(UnitSystem.values, data['unitSystem']);
    final hasOnboardingData =
        data['age'] != null ||
        data['heightCm'] != null ||
        data['currentWeightKg'] != null ||
        data['targetWeightKg'] != null ||
        activity != null ||
        goal != null ||
        data['unitSystem'] != null ||
        data['dailyCalorieTarget'] != null ||
        data['proteinGoalGrams'] != null ||
        data['carbohydrateGoalGrams'] != null ||
        data['fatGoalGrams'] != null ||
        data['waterGoalLiters'] != null ||
        data['weeklyWeightGoalKg'] != null;

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
              dailyCalorieTarget: (data['dailyCalorieTarget'] as num?)?.toInt(),
              proteinGoalGrams: (data['proteinGoalGrams'] as num?)?.toInt(),
              carbohydrateGoalGrams: (data['carbohydrateGoalGrams'] as num?)
                  ?.toInt(),
              fatGoalGrams: (data['fatGoalGrams'] as num?)?.toInt(),
              waterGoalLiters: (data['waterGoalLiters'] as num?)?.toDouble(),
              weeklyWeightGoalKg: (data['weeklyWeightGoalKg'] as num?)
                  ?.toDouble(),
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
