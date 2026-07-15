import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// Reusable controls for a host meal scanner to request local image capture.
/// The host supplies the actual camera/gallery integration through callbacks.
class MealCaptureActions extends StatelessWidget {
  const MealCaptureActions({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    this.enabled = true,
  });

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton.filledTonal(
          tooltip: 'Choose meal photo from gallery',
          onPressed: enabled ? onGalleryPressed : null,
          icon: const Icon(Icons.photo_outlined),
        ),
        const SizedBox(width: AppSpacing.xl),
        SizedBox.square(
          dimension: AppSizes.captureButton,
          child: IconButton.filled(
            tooltip: 'Capture meal photo',
            onPressed: enabled ? onCameraPressed : null,
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ),
      ],
    );
  }
}
