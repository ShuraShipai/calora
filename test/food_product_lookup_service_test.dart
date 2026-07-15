import 'package:calora/features/scanner/services/food_product_lookup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('maps an Open Food Facts product using serving nutrition', () async {
    final service = OpenFoodFactsProductLookupService(
      client: MockClient((request) async {
        expect(request.url.path, '/api/v2/product/1234567890123.json');
        return http.Response('''
          {"status":1,"product":{"product_name":"Oat bar","brands":"Calora Foods","serving_size":"40 g","nutriments":{"energy-kcal_serving":180,"proteins_serving":5.4,"carbohydrates_serving":23,"fat_serving":7.1}}}
        ''', 200);
      }),
    );

    final product = await service.lookupBarcode('1234-5678-90123');

    expect(product?.name, 'Oat bar');
    expect(product?.brand, 'Calora Foods');
    expect(product?.servingLabel, '40 g');
    expect(product?.calories, 180);
    expect(product?.protein, 5);
    expect(product?.carbs, 23);
    expect(product?.fat, 7);
  });

  test('returns null when the barcode is not in Open Food Facts', () async {
    final service = OpenFoodFactsProductLookupService(
      client: MockClient((_) async => http.Response('{"status":0}', 200)),
    );

    expect(await service.lookupBarcode('1234567890123'), isNull);
  });
}
