import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeCameraPreview extends StatelessWidget {
  const BarcodeCameraPreview({
    super.key,
    required this.controller,
    required this.onDetect,
  });

  final MobileScannerController controller;
  final ValueChanged<BarcodeCapture> onDetect;

  @override
  Widget build(BuildContext context) => MobileScanner(
    controller: controller,
    onDetect: onDetect,
    errorBuilder: (context, error, child) => ColoredBox(
      color: context.colors.scannerEnd,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Camera unavailable. Check camera permission and try again.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.onAccent,
            ),
          ),
        ),
      ),
    ),
  );
}
