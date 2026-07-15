import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
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
  bool _analysing = false;
  Timer? _timer;
  ScannerRequest? _request;

  ScannerRequest get request => _request ?? const ScannerRequest.meal();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _capture() {
    if (request.mode == ScannerMode.barcode) {
      showCaloraMessage(
        context,
        'Scanning automatically when a barcode is in view.',
      );
      return;
    }
    if (_analysing) return;
    setState(() => _analysing = true);
    _timer = Timer(AppDurations.scannerAnalysis, () {
      if (!mounted) return;
      setState(() => _analysing = false);
      unawaited(
        Navigator.pushNamed(context, AppRoutes.scanResults, arguments: request),
      );
    });
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = await context.read<ScannerProvider>().detectBarcode(
      capture,
    );
    if (!mounted || barcode == null) return;
    await Navigator.pushNamed(
      context,
      AppRoutes.scanResults,
      arguments: request.withBarcode(barcode),
    );
    if (mounted) {
      await context.read<ScannerProvider>().resumeBarcodeScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    _request ??= ModalRoute.of(context)?.settings.arguments as ScannerRequest?;
    return Consumer<ScannerProvider>(
      builder: (context, scanner, _) => CaloraPage(
        screenId: 'scanner',
        backgroundColor: context.colors.scannerEnd,
        child: ScannerPreview(
          analysing: _analysing || scanner.isProcessingBarcode,
          flashEnabled: scanner.flashEnabled,
          onClose: () {
            unawaited(scanner.stop());
            Navigator.maybePop(context);
          },
          onFlash: () => unawaited(scanner.toggleFlash()),
          onGallery: () => showCaloraMessage(
            context,
            'Gallery picker will be connected later.',
          ),
          onCapture: _capture,
          onCancel: () {
            _timer?.cancel();
            setState(() => _analysing = false);
            if (request.mode == ScannerMode.barcode) {
              unawaited(scanner.resumeBarcodeScanning());
            }
          },
          mode: request.mode.name,
          cameraPreview: request.mode == ScannerMode.barcode
              ? BarcodeCameraPreview(
                  controller: scanner.controller,
                  onDetect: (capture) => unawaited(_onBarcodeDetected(capture)),
                )
              : null,
        ),
      ),
    );
  }
}
