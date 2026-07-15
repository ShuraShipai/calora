import 'dart:convert';

import 'package:calora/features/scanner/models/barcode_product.dart';
import 'package:http/http.dart' as http;

abstract interface class FoodProductLookupService {
  Future<BarcodeProduct?> lookupBarcode(String barcode);
}

class OpenFoodFactsProductLookupService implements FoodProductLookupService {
  OpenFoodFactsProductLookupService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<BarcodeProduct?> lookupBarcode(String barcode) async {
    final normalizedBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalizedBarcode.isEmpty) {
      throw ArgumentError.value(barcode, 'barcode', 'Must contain digits.');
    }

    try {
      final response = await _client.get(
        Uri.https(
          'world.openfoodfacts.org',
          '/api/v2/product/$normalizedBarcode.json',
          <String, String>{
            'fields':
                'product_name,generic_name,brands,serving_size,nutriments',
          },
        ),
        headers: const <String, String>{
          'Accept': 'application/json',
          'User-Agent': 'Calora/1.0',
        },
      );
      if (response.statusCode != 200) {
        throw BarcodeLookupException('Product lookup failed.');
      }

      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic> || body['status'] != 1) return null;
      final product = body['product'];
      if (product is! Map<String, dynamic>) return null;
      final result = BarcodeProduct.fromOpenFoodFacts(
        barcode: normalizedBarcode,
        product: product,
      );
      return result.name.isEmpty ? null : result;
    } on BarcodeLookupException {
      rethrow;
    } on Object catch (_) {
      throw BarcodeLookupException('Could not reach the food database.');
    }
  }
}

class BarcodeLookupException implements Exception {
  const BarcodeLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
