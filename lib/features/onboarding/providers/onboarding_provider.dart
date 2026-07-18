import 'package:calora/core/formatters/measurement_formatter.dart';
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
  ActivityLevel? activityLevel;
  WellnessGoal? goal;
  UnitSystem? unitSystem;
  String dailyCalorieTarget = '';
  String proteinGoal = '';
  String carbohydrateGoal = '';
  String fatGoal = '';
  String waterGoal = '';
  String weeklyWeightGoal = '';

  int get step => _step;
  bool get isFirstStep => _step == 0;
  bool get isLastStep => _step == totalSteps - 1;
  void updateDailyCalorieTarget(String value) => dailyCalorieTarget = value;
  void updateProteinGoal(String value) => proteinGoal = value;
  void updateCarbohydrateGoal(String value) => carbohydrateGoal = value;
  void updateFatGoal(String value) => fatGoal = value;
  void updateWaterGoal(String value) => waterGoal = value;
  void updateWeeklyWeightGoal(String value) => weeklyWeightGoal = value;

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

  void updateName(String value) {
    name = value;
  }

  void updateAge(String value) {
    age = value;
  }

  void updateHeight(String value) {
    height = value;
  }

  void updateCurrentWeight(String value) {
    currentWeight = value;
  }

  void updateTargetWeight(String value) {
    targetWeight = value;
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
    dailyCalorieTarget: int.tryParse(dailyCalorieTarget),
    proteinGoalGrams: int.tryParse(proteinGoal),
    carbohydrateGoalGrams: int.tryParse(carbohydrateGoal),
    fatGoalGrams: int.tryParse(fatGoal),
    waterGoalLiters: _waterGoalLiters,
    weeklyWeightGoalKg: _weeklyWeightGoalKg,
  );

  double? get _waterGoalLiters {
    final value = double.tryParse(waterGoal);
    if (value == null || value <= 0 || unitSystem == null) return null;
    return MeasurementFormatter.waterToMillilitres(value, unitSystem!) / 1000;
  }

  double? get _weeklyWeightGoalKg {
    final value = double.tryParse(weeklyWeightGoal);
    if (value == null || value <= 0 || unitSystem == null) return null;
    return MeasurementFormatter.weightToKg(value, unitSystem!);
  }
}
