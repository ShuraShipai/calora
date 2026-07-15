import 'package:calora/features/diary/models/diary_entry.dart';

/// Nutrition totals derived from saved [DiaryEntry] records.
///
/// Fibre is intentionally absent: diary entries do not persist a fibre value.
class DiaryNutritionTotals {
  const DiaryNutritionTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  const DiaryNutritionTotals.zero()
    : calories = 0,
      protein = 0,
      carbs = 0,
      fat = 0;

  factory DiaryNutritionTotals.fromEntry(DiaryEntry entry) =>
      DiaryNutritionTotals(
        calories: entry.calories,
        protein: entry.protein,
        carbs: entry.carbs,
        fat: entry.fat,
      );

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  DiaryNutritionTotals add(DiaryNutritionTotals other) => DiaryNutritionTotals(
    calories: calories + other.calories,
    protein: protein + other.protein,
    carbs: carbs + other.carbs,
    fat: fat + other.fat,
  );
}
