import 'package:calora/features/scanner/models/usda_food_nutrition.dart';
import 'package:calora/features/scanner/providers/usda_nutrition_lookup_provider.dart';
import 'package:calora/features/scanner/services/usda_food_nutrition_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the nutrition returned by the injected service', () async {
    final provider = UsdaNutritionLookupProvider(_SuccessService());

    final nutrition = await provider.lookup(foodName: 'Apple', grams: 120);

    expect(provider.isLoading, isFalse);
    expect(nutrition?.calories, 62);
    expect(provider.nutrition?.grams, 120);
    expect(provider.errorMessage, isNull);
  });

  test('exposes a service error for the presentation layer', () async {
    final provider = UsdaNutritionLookupProvider(_FailureService());

    expect(await provider.lookup(foodName: 'Apple', grams: 100), isNull);
    expect(provider.errorMessage, 'USDA food lookup is not configured.');
  });
}

class _SuccessService implements UsdaFoodNutritionService {
  @override
  Future<UsdaFoodNutrition?> lookup({
    required String foodName,
    required double grams,
  }) async => UsdaFoodNutrition(
    fdcId: 1,
    name: foodName,
    grams: grams,
    calories: 62,
    protein: 0,
    carbs: 17,
    fat: 0,
    fiber: 3,
    sugar: 12,
  );
}

class _FailureService implements UsdaFoodNutritionService {
  @override
  Future<UsdaFoodNutrition?> lookup({
    required String foodName,
    required double grams,
  }) => throw const UsdaNutritionLookupException(
    'USDA food lookup is not configured.',
  );
}
