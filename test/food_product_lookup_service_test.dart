import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:calora/features/scanner/services/food_product_lookup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps an Open Food Facts product using serving nutrition', () async {
    final service = OpenFoodFactsProductLookupService(
      networkClient: _FakeNetworkClient((uri, headers) {
        expect(uri.path, '/api/v2/product/1234567890123.json');
        expect(headers?['User-Agent'], 'Calora/1.0');
        return <String, dynamic>{
          'status': 1,
          'product': <String, dynamic>{
            'product_name': 'Oat bar',
            'brands': 'Calora Foods',
            'serving_size': '40 g',
            'nutriments': <String, dynamic>{
              'energy-kcal_serving': 180,
              'proteins_serving': 5.4,
              'carbohydrates_serving': 23,
              'fat_serving': 7.1,
            },
          },
        };
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
      networkClient: _FakeNetworkClient(
        (_, _) => <String, dynamic>{'status': 0},
      ),
    );

    expect(await service.lookupBarcode('1234567890123'), isNull);
  });

  test('preserves the network layer offline message', () async {
    final service = OpenFoodFactsProductLookupService(
      networkClient: _FakeNetworkClient(
        (_, _) => throw const NetworkException.offline(),
      ),
    );

    expect(
      () => service.lookupBarcode('1234567890123'),
      throwsA(
        isA<BarcodeLookupException>().having(
          (error) => error.message,
          'message',
          'No internet connection. Check your connection and try again.',
        ),
      ),
    );
  });
}

class _FakeNetworkClient implements NetworkClient {
  _FakeNetworkClient(this._response);

  final Map<String, dynamic> Function(Uri uri, Map<String, String>? headers)
  _response;

  @override
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    Map<String, String>? headers,
  }) async => _response(uri, headers);
}
