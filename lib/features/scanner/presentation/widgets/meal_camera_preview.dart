import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Coordinates the preview's camera actions with the scanner screen controls.
class MealCameraCaptureController {
  Future<void> Function()? _capture;
  Future<bool> Function()? _toggleFlash;

  Future<void> capture() async {
    final capture = _capture;
    if (capture == null) {
      throw StateError('The meal camera is not ready.');
    }
    await capture();
  }

  Future<bool> toggleFlash() async {
    final toggleFlash = _toggleFlash;
    if (toggleFlash == null) return false;
    return toggleFlash();
  }

  void _attach({
    required Future<void> Function() capture,
    required Future<bool> Function() toggleFlash,
  }) {
    _capture = capture;
    _toggleFlash = toggleFlash;
  }

  void _detach() {
    _capture = null;
    _toggleFlash = null;
  }
}

class MealCameraPreview extends StatefulWidget {
  const MealCameraPreview({
    super.key,
    required this.captureController,
    required this.onCaptured,
  });

  final MealCameraCaptureController captureController;
  final ValueChanged<MealImage> onCaptured;

  @override
  State<MealCameraPreview> createState() => _MealCameraPreviewState();
}

class _MealCameraPreviewState extends State<MealCameraPreview> {
  CameraController? _camera;
  String? _errorMessage;
  bool _flashEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (candidate) => candidate.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _camera = controller);
      widget.captureController._attach(
        capture: _capture,
        toggleFlash: _toggleFlash,
      );
    } on CameraException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = _cameraErrorMessage(error));
      }
    } on Object {
      if (mounted) {
        setState(
          () => _errorMessage =
              'Could not start the camera. Please close and reopen Calora.',
        );
      }
    }
  }

  String _cameraErrorMessage(CameraException error) => switch (error.code) {
    'CameraAccessDenied' =>
      'Camera permission was denied. Allow it, then reopen Scan food.',
    'CameraAccessDeniedWithoutPrompt' =>
      'Camera access is off. Go to Settings > Calora > Camera and enable it.',
    'CameraAccessRestricted' =>
      'Camera access is restricted by this device’s settings.',
    _ => 'Could not start the camera (${error.code}). Please try again.',
  };

  Future<void> _capture() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) {
      throw StateError('The meal camera is not ready.');
    }
    final photo = await camera.takePicture();
    if (!mounted) return;
    widget.onCaptured(
      MealImage(
        path: photo.path,
        source: MealImageSource.camera,
        capturedAt: DateTime.now(),
      ),
    );
  }

  Future<bool> _toggleFlash() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return _flashEnabled;
    final enabled = !_flashEnabled;
    await camera.setFlashMode(enabled ? FlashMode.torch : FlashMode.off);
    if (mounted) setState(() => _flashEnabled = enabled);
    return enabled;
  }

  @override
  void dispose() {
    widget.captureController._detach();
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = _camera;
    if (camera != null && camera.value.isInitialized) {
      return CameraPreview(camera);
    }
    return ColoredBox(
      color: context.colors.scannerEnd,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _errorMessage == null
              ? const CircularProgressIndicator()
              : Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colors.onAccent,
                  ),
                ),
        ),
      ),
    );
  }
}
