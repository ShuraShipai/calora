import 'package:calora/features/scanner/models/usda_food_nutrition.dart';
import 'package:calora/features/scanner/services/usda_food_nutrition_service.dart';
import 'package:flutter/foundation.dart';

class UsdaNutritionLookupProvider extends ChangeNotifier {
  UsdaNutritionLookupProvider(this._service);

  final UsdaFoodNutritionService _service;
  bool _isLoading = false;
  UsdaFoodNutrition? _nutrition;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  UsdaFoodNutrition? get nutrition => _nutrition;
  String? get errorMessage => _errorMessage;

  Future<UsdaFoodNutrition?> lookup({
    required String foodName,
    required double grams,
  }) async {
    if (_isLoading) return null;
    _isLoading = true;
    _nutrition = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final nutrition = await _service.lookup(foodName: foodName, grams: grams);
      _nutrition = nutrition;
      if (nutrition == null) _errorMessage = 'No USDA food was found.';
      return nutrition;
    } on UsdaNutritionLookupException catch (error) {
      _errorMessage = error.message;
      return null;
    } on Object catch (_) {
      _errorMessage = 'Could not look up nutrition.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    if (_nutrition == null && _errorMessage == null) return;
    _nutrition = null;
    _errorMessage = null;
    notifyListeners();
  }
}
