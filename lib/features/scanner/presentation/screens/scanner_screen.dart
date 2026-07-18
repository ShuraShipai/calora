import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/scanner/models/scan_result_outcome.dart';
import 'package:calora/features/scanner/models/scanner_request.dart';
import 'package:calora/features/scanner/presentation/widgets/barcode_camera_preview.dart';
import 'package:calora/features/scanner/presentation/widgets/scanner_preview.dart';
import 'package:calora/features/scanner/providers/scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  ScannerRequest? _request;

  ScannerRequest get request => _request ?? const ScannerRequest.barcode();

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = await context.read<ScannerProvider>().detectBarcode(
      capture,
    );
    if (!mounted || barcode == null) return;
    ScanResultOutcome? outcome;
    try {
      outcome = await Navigator.pushNamed<ScanResultOutcome>(
        context,
        AppRoutes.scanResults,
        arguments: request.withBarcode(barcode),
      );
    } on Object {
      if (mounted) {
        showCaloraMessage(context, 'Could not open the product result.');
      }
    }
    if (!mounted) return;
    if (outcome == ScanResultOutcome.saved) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.diary,
        (route) => route.settings.name == AppRoutes.home,
      );
      return;
    }
    await context.read<ScannerProvider>().resumeBarcodeScanning();
  }

  @override
  Widget build(BuildContext context) {
    _request ??= ModalRoute.of(context)?.settings.arguments as ScannerRequest?;
    return Consumer<ScannerProvider>(
      builder: (context, scanner, _) => CaloraPage(
        screenId: 'scanner',
        backgroundColor: context.colors.scannerEnd,
        child: ScannerPreview(
          analysing: scanner.isProcessingBarcode,
          flashEnabled: scanner.flashEnabled,
          onClose: () {
            unawaited(scanner.stop());
            Navigator.maybePop(context);
          },
          onFlash: () => unawaited(scanner.toggleFlash()),
          onCancel: () => unawaited(scanner.resumeBarcodeScanning()),
          cameraPreview: BarcodeCameraPreview(
            controller: scanner.controller,
            onDetect: (capture) => unawaited(_onBarcodeDetected(capture)),
          ),
        ),
      ),
    );
  }
}
