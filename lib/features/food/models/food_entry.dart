class FoodEntry {
  const FoodEntry({
    required this.name,
    required this.serving,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final String name;
  final String serving;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
}

class MealEntries {
  MealEntries({required this.label, required this.entries});

  final String label;
  final List<FoodEntry> entries;

  int get totalKcal => entries.fold(0, (total, entry) => total + entry.kcal);
}
