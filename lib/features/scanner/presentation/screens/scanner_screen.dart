import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/scanner/presentation/widgets/scanner_preview.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _analysing = false;
  bool _flashEnabled = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _capture() {
    if (_analysing) return;
    setState(() => _analysing = true);
    _timer = Timer(AppDurations.scannerAnalysis, () {
      if (!mounted) return;
      setState(() => _analysing = false);
      unawaited(Navigator.pushNamed(context, AppRoutes.scanResults));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CaloraPage(
      screenId: 'scanner',
      backgroundColor: context.colors.scannerEnd,
      child: ScannerPreview(
        analysing: _analysing,
        flashEnabled: _flashEnabled,
        onClose: () => Navigator.maybePop(context),
        onFlash: () => setState(() => _flashEnabled = !_flashEnabled),
        onGallery: () => showCaloraMessage(
          context,
          'Gallery picker will be connected later.',
        ),
        onCapture: _capture,
        onCancel: () {
          _timer?.cancel();
          setState(() => _analysing = false);
        },
      ),
    );
  }
}
