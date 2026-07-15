import 'dart:convert';

import 'package:calora/features/scanner/models/usda_food_nutrition.dart';
import 'package:http/http.dart' as http;

abstract interface class UsdaFoodNutritionService {
  Future<UsdaFoodNutrition?> lookup({
    required String foodName,
    required double grams,
  });
}

class FoodDataCentralNutritionService implements UsdaFoodNutritionService {
  FoodDataCentralNutritionService({http.Client? client, String? apiKey})
    : _client = client ?? http.Client(),
      _apiKey = apiKey ?? const String.fromEnvironment('USDA_API_KEY');

  final http.Client _client;
  final String _apiKey;

  @override
  Future<UsdaFoodNutrition?> lookup({
    required String foodName,
    required double grams,
  }) async {
    final query = foodName.trim();
    if (query.isEmpty) {
      throw ArgumentError.value(foodName, 'foodName', 'Must not be empty.');
    }
    if (grams <= 0) {
      throw ArgumentError.value(grams, 'grams', 'Must be greater than zero.');
    }
    if (_apiKey.isEmpty) {
      throw const UsdaNutritionLookupException(
        'USDA food lookup is not configured.',
      );
    }

    try {
      final searchResponse = await _client.get(
        Uri.https('api.nal.usda.gov', '/fdc/v1/foods/search', <String, String>{
          'api_key': _apiKey,
          'query': query,
          'pageSize': '1',
        }),
        headers: const <String, String>{'Accept': 'application/json'},
      );
      if (searchResponse.statusCode != 200) {
        throw const UsdaNutritionLookupException('USDA food lookup failed.');
      }

      final search = _map(jsonDecode(searchResponse.body));
      final foods = search['foods'];
      if (foods is! List || foods.isEmpty) return null;
      final firstFood = _map(foods.first);
      final id = _id(firstFood['fdcId']);
      if (id == null) {
        return UsdaFoodNutrition.fromFoodData(food: firstFood, grams: grams);
      }

      final foodResponse = await _client.get(
        Uri.https('api.nal.usda.gov', '/fdc/v1/food/$id', <String, String>{
          'api_key': _apiKey,
        }),
        headers: const <String, String>{'Accept': 'application/json'},
      );
      if (foodResponse.statusCode != 200) {
        throw const UsdaNutritionLookupException('USDA food lookup failed.');
      }

      return UsdaFoodNutrition.fromFoodData(
        food: _map(jsonDecode(foodResponse.body)),
        grams: grams,
      );
    } on UsdaNutritionLookupException {
      rethrow;
    } on ArgumentError {
      rethrow;
    } on Object catch (_) {
      throw const UsdaNutritionLookupException(
        'Could not reach the USDA food database.',
      );
    }
  }

  static Map<String, dynamic> _map(Object? value) => value is Map
      ? value.map((key, value) => MapEntry(key.toString(), value))
      : const <String, dynamic>{};

  static int? _id(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
}

class UsdaNutritionLookupException implements Exception {
  const UsdaNutritionLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
