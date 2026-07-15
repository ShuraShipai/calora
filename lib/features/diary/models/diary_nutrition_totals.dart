import 'package:calora/features/diary/models/diary_entry.dart';

/// Nutrition totals derived from saved [DiaryEntry] records.
class DiaryNutritionTotals {
  const DiaryNutritionTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
  });

  const DiaryNutritionTotals.zero()
    : calories = 0,
      protein = 0,
      carbs = 0,
      fat = 0,
      fiber = 0,
      sugar = 0;

  factory DiaryNutritionTotals.fromEntry(DiaryEntry entry) =>
      DiaryNutritionTotals(
        calories: entry.calories,
        protein: entry.protein,
        carbs: entry.carbs,
        fat: entry.fat,
        fiber: entry.fiber ?? 0,
        sugar: entry.sugar ?? 0,
      );

  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;

  DiaryNutritionTotals add(DiaryNutritionTotals other) => DiaryNutritionTotals(
    calories: calories + other.calories,
    protein: protein + other.protein,
    carbs: carbs + other.carbs,
    fat: fat + other.fat,
    fiber: fiber + other.fiber,
    sugar: sugar + other.sugar,
  );
}
