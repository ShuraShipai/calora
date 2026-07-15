import 'package:calora/features/scanner/services/usda_food_nutrition_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('looks up USDA nutrition and scales it to confirmed grams', () async {
    final service = FoodDataCentralNutritionService(
      apiKey: 'test-key',
      client: MockClient((request) async {
        expect(request.url.queryParameters['api_key'], 'test-key');
        if (request.url.path == '/fdc/v1/foods/search') {
          expect(request.url.queryParameters['query'], 'Apple');
          return http.Response(
            '{"foods":[{"fdcId":123,"description":"Apple"}]}',
            200,
          );
        }
        expect(request.url.path, '/fdc/v1/food/123');
        return http.Response('''
          {"fdcId":123,"description":"Apple","foodNutrients":[
            {"nutrientId":1008,"amount":52},
            {"nutrientId":1003,"amount":0.3},
            {"nutrientId":1005,"amount":14},
            {"nutrientId":1004,"amount":0.2},
            {"nutrientId":1079,"amount":2.4},
            {"nutrientId":2000,"amount":10.4}
          ]}
        ''', 200);
      }),
    );

    final nutrition = await service.lookup(foodName: ' Apple ', grams: 150);

    expect(nutrition?.name, 'Apple');
    expect(nutrition?.fdcId, 123);
    expect(nutrition?.calories, 78);
    expect(nutrition?.protein, 0);
    expect(nutrition?.carbs, 21);
    expect(nutrition?.fat, 0);
    expect(nutrition?.fiber, 4);
    expect(nutrition?.sugar, 16);
  });

  test('fails clearly when USDA_API_KEY is not supplied', () async {
    final service = FoodDataCentralNutritionService(
      client: MockClient((_) async => throw StateError('not called')),
    );

    await expectLater(
      service.lookup(foodName: 'Apple', grams: 100),
      throwsA(
        isA<UsdaNutritionLookupException>().having(
          (error) => error.message,
          'message',
          'USDA food lookup is not configured.',
        ),
      ),
    );
  });
}
