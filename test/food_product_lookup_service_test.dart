import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:calora/features/scanner/models/barcode_product.dart';
import 'package:calora/features/scanner/services/food_product_lookup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps an Open Food Facts product using serving nutrition', () async {
    final service = OpenFoodFactsProductLookupService(
      networkClient: _FakeNetworkClient((uri, headers) {
        expect(uri.path, '/api/v3/product/1234567890123');
        expect(
          headers?['User-Agent'],
          'Calora/1.0 (https://github.com/ShuraShipai/calora)',
        );
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
        (_, _) => <String, dynamic>{'product': null},
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

  test('preserves the network layer server message', () async {
    final service = OpenFoodFactsProductLookupService(
      networkClient: _FakeNetworkClient(
        (_, _) => throw const NetworkException.server(),
      ),
    );

    expect(
      () => service.lookupBarcode('1234567890123'),
      throwsA(
        isA<BarcodeLookupException>().having(
          (error) => error.message,
          'message',
          'The food database is unavailable right now. Please try again.',
        ),
      ),
    );
  });

  test('uses 100 g nutrition when serving macros are incomplete', () {
    final product = BarcodeProduct.fromOpenFoodFacts(
      barcode: '3017620422003',
      product: <String, dynamic>{
        'product_name': 'Chocolate spread',
        'serving_size': '15 g',
        'nutriments': <String, dynamic>{
          'energy-kcal_100g': 539,
          'proteins_100g': 6.3,
          'carbohydrates_100g': 57.5,
          'fat_100g': 30.9,
          'nova-group_serving': 4,
        },
      },
    );

    expect(product.servingLabel, '100 g');
    expect(product.calories, 539);
    expect(product.protein, 6);
    expect(product.carbs, 58);
    expect(product.fat, 31);
  });

  test('rejects an alphanumeric barcode without making a lookup', () async {
    final service = OpenFoodFactsProductLookupService(
      networkClient: _FakeNetworkClient(
        (_, _) => fail('The network client should not be called.'),
      ),
    );

    expect(
      () => service.lookupBarcode('ABC-1234567890'),
      throwsA(
        isA<BarcodeLookupException>().having(
          (error) => error.message,
          'message',
          'Unsupported product barcode.',
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
