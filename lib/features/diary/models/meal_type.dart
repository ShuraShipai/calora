enum MealType { breakfast, lunch, dinner, snacks }

extension MealTypeX on MealType {
  String get label => switch (this) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snacks => 'Snacks',
  };
  String get storedValue => name;
  static MealType fromStored(String value) => MealType.values.firstWhere(
    (type) => type.name == value.toLowerCase(),
    orElse: () => MealType.snacks,
  );
}

class MealSelectionArguments {
  const MealSelectionArguments(this.mealType);
  final MealType mealType;
}
