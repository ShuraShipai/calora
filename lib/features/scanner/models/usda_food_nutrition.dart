/// Normalized nutrition from USDA FoodData Central for a confirmed amount.
///
/// FoodData Central returns nutrients per 100 g. This value scales those
/// nutrients to the amount the person confirmed before it is added to Diary.
class UsdaFoodNutrition {
  const UsdaFoodNutrition({
    required this.fdcId,
    required this.name,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
  });

  factory UsdaFoodNutrition.fromFoodData({
    required Map<String, dynamic> food,
    required double grams,
  }) {
    if (grams <= 0) {
      throw ArgumentError.value(grams, 'grams', 'Must be greater than zero.');
    }

    final nutrients = _nutrients(food['foodNutrients']);
    final multiplier = grams / 100;
    return UsdaFoodNutrition(
      fdcId: _int(food['fdcId']),
      name: _firstText(food, const <String>[
        'description',
        'lowercaseDescription',
        'brandOwner',
      ]),
      grams: grams,
      calories: _scaled(
        nutrients,
        const <int>{1008},
        const <String>{'energy'},
        multiplier,
      ),
      protein: _scaled(
        nutrients,
        const <int>{1003},
        const <String>{'protein'},
        multiplier,
      ),
      carbs: _scaled(
        nutrients,
        const <int>{1005},
        const <String>{'carbohydrate, by difference', 'carbohydrate'},
        multiplier,
      ),
      fat: _scaled(
        nutrients,
        const <int>{1004},
        const <String>{'total lipid (fat)', 'total lipid'},
        multiplier,
      ),
      fiber: _scaled(
        nutrients,
        const <int>{1079},
        const <String>{'fiber, total dietary', 'dietary fiber'},
        multiplier,
      ),
      sugar: _scaled(
        nutrients,
        const <int>{2000},
        const <String>{'sugars, total including nlea', 'sugars, total'},
        multiplier,
      ),
    );
  }

  final int? fdcId;
  final String name;
  final double grams;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;

  static List<Map<String, dynamic>> _nutrients(Object? value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map(
          (nutrient) =>
              nutrient.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList(growable: false);
  }

  static int _scaled(
    List<Map<String, dynamic>> nutrients,
    Set<int> ids,
    Set<String> names,
    double multiplier,
  ) {
    final nutrient = nutrients.where((item) {
      final id = _int(item['nutrientId'] ?? item['nutrientNumber']);
      if (id != null && ids.contains(id)) return true;
      final name = (item['nutrientName'] ?? item['name'])
          ?.toString()
          .trim()
          .toLowerCase();
      return name != null && names.contains(name);
    }).firstOrNull;
    final amount = _number(nutrient?['amount'] ?? nutrient?['value']) ?? 0;
    return (amount * multiplier).round();
  }

  static String _firstText(Map<String, dynamic> food, List<String> keys) {
    for (final key in keys) {
      final value = food[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  static int? _int(Object? value) => _number(value)?.toInt();

  static double? _number(Object? value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '');
}
