import 'package:calora/features/scanner/models/barcode_product.dart';
import 'package:calora/features/scanner/services/food_product_lookup_service.dart';
import 'package:flutter/foundation.dart';

class BarcodeLookupProvider extends ChangeNotifier {
  BarcodeLookupProvider(this._service);

  final FoodProductLookupService _service;
  bool _isLoading = false;
  BarcodeProduct? _product;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  BarcodeProduct? get product => _product;
  String? get errorMessage => _errorMessage;

  Future<BarcodeProduct?> lookup(String barcode) async {
    if (_isLoading) return null;
    _isLoading = true;
    _product = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _service.lookupBarcode(barcode);
      _product = product;
      if (product == null) _errorMessage = 'No product found for this barcode.';
      return product;
    } on BarcodeLookupException catch (error) {
      _errorMessage = error.message;
      return null;
    } on Object catch (_) {
      _errorMessage = 'Could not look up that barcode.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    if (_product == null && _errorMessage == null) return;
    _product = null;
    _errorMessage = null;
    notifyListeners();
  }
}
