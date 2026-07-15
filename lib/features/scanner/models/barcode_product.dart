/// Nutrition information returned for a packaged food barcode.
///
/// Values represent the product's advertised serving when Open Food Facts
/// supplies them, otherwise its 100 g values.
class BarcodeProduct {
  const BarcodeProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.servingLabel,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory BarcodeProduct.fromOpenFoodFacts({
    required String barcode,
    required Map<String, dynamic> product,
  }) {
    final nutriments = _map(product['nutriments']);
    final hasServingNutrition = nutriments.keys.any(
      (key) => key.endsWith('_serving'),
    );
    final suffix = hasServingNutrition ? '_serving' : '_100g';
    final servingSize = _text(product['serving_size']);

    return BarcodeProduct(
      barcode: barcode,
      name: _text(product['product_name']).isNotEmpty
          ? _text(product['product_name'])
          : _text(product['generic_name']),
      brand: _text(product['brands']),
      servingLabel: servingSize.isNotEmpty
          ? servingSize
          : hasServingNutrition
          ? '1 serving'
          : '100 g',
      calories: _nutrition(nutriments, 'energy-kcal$suffix'),
      protein: _nutrition(nutriments, 'proteins$suffix'),
      carbs: _nutrition(nutriments, 'carbohydrates$suffix'),
      fat: _nutrition(nutriments, 'fat$suffix'),
    );
  }

  final String barcode;
  final String name;
  final String brand;
  final String servingLabel;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  static Map<String, dynamic> _map(Object? value) => value is Map
      ? value.map((key, value) => MapEntry(key.toString(), value))
      : const <String, dynamic>{};

  static String _text(Object? value) => value is String ? value.trim() : '';

  static int _nutrition(Map<String, dynamic> nutriments, String key) {
    final value = nutriments[key];
    if (value is num) return value.round();
    return num.tryParse(value?.toString() ?? '')?.round() ?? 0;
  }
}
