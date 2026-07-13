import 'package:calora/core/models/user_profile.dart';
import 'package:flutter/foundation.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider({String initialName = ''}) : name = initialName;

  static const totalSteps = 4;

  int _step = 0;
  String name;
  String age = '';
  String height = '';
  String currentWeight = '';
  String targetWeight = '';
  ActivityLevel activityLevel = ActivityLevel.sedentary;
  WellnessGoal goal = WellnessGoal.loseWeight;
  UnitSystem unitSystem = UnitSystem.metric;

  int get step => _step;
  bool get isFirstStep => _step == 0;
  bool get isLastStep => _step == totalSteps - 1;
  int get dailyCalorieTarget => 1840;

  void next() {
    if (isLastStep) return;
    _step++;
    notifyListeners();
  }

  void back() {
    if (isFirstStep) return;
    _step--;
    notifyListeners();
  }

  void selectActivity(ActivityLevel value) {
    if (activityLevel == value) return;
    activityLevel = value;
    notifyListeners();
  }

  void selectGoal(WellnessGoal value) {
    if (goal == value) return;
    goal = value;
    notifyListeners();
  }

  void selectUnitSystem(UnitSystem value) {
    if (unitSystem == value) return;
    unitSystem = value;
    notifyListeners();
  }

  OnboardingDetails get details => OnboardingDetails(
    age: int.tryParse(age),
    heightCm: double.tryParse(height),
    currentWeightKg: double.tryParse(currentWeight),
    targetWeightKg: double.tryParse(targetWeight),
    activityLevel: activityLevel,
    goal: goal,
    unitSystem: unitSystem,
    dailyCalorieTarget: dailyCalorieTarget,
  );
}
