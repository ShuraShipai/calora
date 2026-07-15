import 'dart:async';

import 'package:calora/features/scanner/services/barcode_scanner_service.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Coordinates scanner UI state and isolates the camera controller from widgets.
class ScannerProvider extends ChangeNotifier {
  ScannerProvider(this._service);

  final BarcodeScannerService _service;
  bool _isProcessingBarcode = false;
  bool _flashEnabled = false;

  MobileScannerController get controller => _service.controller;
  bool get isProcessingBarcode => _isProcessingBarcode;
  bool get flashEnabled => _flashEnabled;

  Future<void> toggleFlash() async {
    await _service.toggleTorch();
    _flashEnabled = !_flashEnabled;
    notifyListeners();
  }

  Future<String?> detectBarcode(BarcodeCapture capture) async {
    if (_isProcessingBarcode) return null;
    final value = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (value.isEmpty) return null;

    _isProcessingBarcode = true;
    notifyListeners();
    try {
      await _service.stop();
      return value;
    } catch (_) {
      _isProcessingBarcode = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> resumeBarcodeScanning() async {
    if (!_isProcessingBarcode) return;
    _isProcessingBarcode = false;
    notifyListeners();
    await _service.start();
  }

  Future<void> stop() => _service.stop();

  @override
  void dispose() {
    unawaited(_service.dispose());
    super.dispose();
  }
}
