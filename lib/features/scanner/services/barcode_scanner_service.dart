import 'package:mobile_scanner/mobile_scanner.dart';

/// Owns the camera SDK controller used while scanning product barcodes.
class BarcodeScannerService {
  MobileScannerController? _controller;

  MobileScannerController get controller =>
      _controller ??= MobileScannerController(
        formats: const <BarcodeFormat>[
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.code93,
          BarcodeFormat.itf14,
        ],
        detectionSpeed: DetectionSpeed.noDuplicates,
      );

  Future<void> toggleTorch() => controller.toggleTorch();

  Future<void> stop() => controller.stop();

  Future<void> start() => controller.start();

  Future<void> dispose() async {
    await _controller?.dispose();
  }
}
