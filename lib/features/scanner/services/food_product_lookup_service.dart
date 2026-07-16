import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:calora/features/scanner/models/barcode_product.dart';

abstract interface class FoodProductLookupService {
  Future<BarcodeProduct?> lookupBarcode(String barcode);
}

class OpenFoodFactsProductLookupService implements FoodProductLookupService {
  factory OpenFoodFactsProductLookupService({
    required NetworkClient networkClient,
  }) => OpenFoodFactsProductLookupService._(networkClient);

  OpenFoodFactsProductLookupService._(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<BarcodeProduct?> lookupBarcode(String barcode) async {
    if (!RegExp(r'^[0-9 -]+$').hasMatch(barcode)) {
      throw const BarcodeLookupException('Unsupported product barcode.');
    }
    final normalizedBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    if (!RegExp(r'^(?:[0-9]{8}|[0-9]{12,14})$').hasMatch(normalizedBarcode)) {
      throw const BarcodeLookupException('Unsupported product barcode.');
    }

    try {
      return await _lookupOnHost(
        barcode: normalizedBarcode,
        host: 'world.openfoodfacts.org',
      );
    } on BarcodeLookupException {
      rethrow;
    } on NetworkException catch (error) {
      if (error.kind == NetworkExceptionKind.server) {
        try {
          return await _lookupOnHost(
            barcode: normalizedBarcode,
            host: 'api.openfoodfacts.org',
          );
        } on NetworkException catch (fallbackError) {
          throw BarcodeLookupException(fallbackError.message);
        }
      }
      throw BarcodeLookupException(error.message);
    } on Object catch (_) {
      throw BarcodeLookupException('Could not reach the food database.');
    }
  }

  Future<BarcodeProduct?> _lookupOnHost({
    required String barcode,
    required String host,
  }) async {
    final body = await _networkClient.getJson(
      Uri.https(host, '/api/v2/product/$barcode.json', <String, String>{
        'fields': 'product_name,generic_name,brands,serving_size,nutriments',
      }),
      headers: const <String, String>{
        'Accept': 'application/json',
        'User-Agent': 'Calora/1.0',
      },
    );
    if (body['status'] != 1) return null;
    final product = body['product'];
    if (product is! Map<String, dynamic>) return null;
    final result = BarcodeProduct.fromOpenFoodFacts(
      barcode: barcode,
      product: product,
    );
    return result.name.isEmpty ? null : result;
  }
}

class BarcodeLookupException implements Exception {
  const BarcodeLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
