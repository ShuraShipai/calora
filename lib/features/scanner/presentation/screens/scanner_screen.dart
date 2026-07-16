import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/models/scan_result_outcome.dart';
import 'package:calora/features/scanner/models/scanner_request.dart';
import 'package:calora/features/scanner/presentation/widgets/barcode_camera_preview.dart';
import 'package:calora/features/scanner/presentation/widgets/meal_camera_preview.dart';
import 'package:calora/features/scanner/presentation/widgets/scanner_preview.dart';
import 'package:calora/features/scanner/providers/meal_capture_provider.dart';
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
  final _mealCameraController = MealCameraCaptureController();
  bool _mealFlashEnabled = false;

  ScannerRequest get request => _request ?? const ScannerRequest.meal();

  void _captureBarcode() {
    if (request.mode == ScannerMode.barcode) {
      showCaloraMessage(
        context,
        'Scanning automatically when a barcode is in view.',
      );
    }
  }

  Future<void> _captureMeal(MealImageSource source) async {
    final mealCapture = context.read<MealCaptureProvider>();
    await mealCapture.capture(source);
    await _showMealResult(mealCapture);
  }

  Future<void> _captureMealFromCamera() async {
    try {
      await _mealCameraController.capture();
    } on Object {
      if (mounted) {
        showCaloraMessage(context, 'Could not capture a meal photo.');
      }
    }
  }

  Future<void> _analyseCapturedMeal(MealImage image) async {
    final mealCapture = context.read<MealCaptureProvider>();
    await mealCapture.analyse(image);
    await _showMealResult(mealCapture);
  }

  Future<void> _showMealResult(MealCaptureProvider mealCapture) async {
    if (!mounted) return;
    final image = mealCapture.image;
    if (image == null) {
      showCaloraMessage(
        context,
        mealCapture.errorMessage ?? 'Could not capture a meal photo.',
      );
      return;
    }
    final result = mealCapture.result;
    if (result == null || !result.isAvailable) {
      showCaloraMessage(
        context,
        result?.unavailableMessage ??
            'No food could be identified from this photo.',
      );
      mealCapture.clear();
      return;
    }
    await Navigator.pushNamed(
      context,
      AppRoutes.scanResults,
      arguments: request.withMealScan(image: image, suggestions: result.labels),
    );
    if (mounted) mealCapture.clear();
  }

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
    return Consumer2<ScannerProvider, MealCaptureProvider>(
      builder: (context, scanner, mealCapture, _) => CaloraPage(
        screenId: 'scanner',
        backgroundColor: context.colors.scannerEnd,
        child: ScannerPreview(
          analysing: mealCapture.isLoading || scanner.isProcessingBarcode,
          flashEnabled: request.mode == ScannerMode.meal
              ? _mealFlashEnabled
              : scanner.flashEnabled,
          onClose: () {
            unawaited(scanner.stop());
            Navigator.maybePop(context);
          },
          onFlash: request.mode == ScannerMode.meal
              ? () => unawaited(_toggleMealFlash())
              : () => unawaited(scanner.toggleFlash()),
          onGallery: request.mode == ScannerMode.meal
              ? () => unawaited(_captureMeal(MealImageSource.gallery))
              : () => showCaloraMessage(
                  context,
                  'Choose a barcode with the camera.',
                ),
          onCapture: request.mode == ScannerMode.meal
              ? () => unawaited(_captureMealFromCamera())
              : _captureBarcode,
          onCancel: () {
            mealCapture.clear();
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
              : MealCameraPreview(
                  captureController: _mealCameraController,
                  onCaptured: (image) => unawaited(_analyseCapturedMeal(image)),
                ),
        ),
      ),
    );
  }

  Future<void> _toggleMealFlash() async {
    final enabled = await _mealCameraController.toggleFlash();
    if (mounted) setState(() => _mealFlashEnabled = enabled);
  }
}
