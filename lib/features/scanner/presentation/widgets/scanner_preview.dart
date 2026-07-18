import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ScannerPreview extends StatelessWidget {
  const ScannerPreview({
    super.key,
    required this.analysing,
    required this.flashEnabled,
    required this.onClose,
    required this.onFlash,
    required this.onCancel,
    this.cameraPreview,
  });

  final bool analysing;
  final bool flashEnabled;
  final VoidCallback onClose;
  final VoidCallback onFlash;
  final VoidCallback onCancel;
  final Widget? cameraPreview;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            context.colors.scannerStart,
            context.colors.scannerEnd,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          if (cameraPreview != null) Positioned.fill(child: cameraPreview!),
          Center(
            child: FractionallySizedBox(
              widthFactor: AppRatios.scannerFrameWidth,
              child: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.onAccent.withValues(
                        alpha: AppOpacity.disabled,
                      ),
                      width: AppStrokes.scanner,
                    ),
                    borderRadius: BorderRadius.circular(AppRadii.sheet),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.page,
            right: AppSpacing.page,
            top: AppSpacing.sectionGap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _control(
                  context,
                  tooltip: 'Close scanner',
                  icon: Icons.close,
                  onPressed: onClose,
                ),
                _control(
                  context,
                  tooltip: 'Flash',
                  icon: flashEnabled ? Icons.flash_on : Icons.flash_off,
                  onPressed: onFlash,
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.page,
            right: AppSpacing.page,
            bottom: AppSpacing.sectionGap,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.scannerEnd.withValues(
                      alpha: AppOpacity.scrim,
                    ),
                    borderRadius: AppRadii.pillBorder,
                  ),
                  child: Text(
                    'Place the product barcode inside the frame.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.onAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (analysing)
            Positioned.fill(
              child: ColoredBox(
                color: context.colors.scannerEnd.withValues(
                  alpha: AppOpacity.disabled + AppOpacity.scrim,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox.square(
                      dimension: AppSizes.spinner,
                      child: CircularProgressIndicator(
                        strokeWidth: AppStrokes.spinner,
                        color: context.colors.onAccent,
                        backgroundColor: context.colors.onAccent.withValues(
                          alpha: AppOpacity.scannerControl,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text(
                      'Looking up product',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colors.onAccent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    TextButton(
                      onPressed: onCancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: context.colors.onAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _control(
    BuildContext context, {
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    double size = AppSizes.scannerControl,
  }) {
    return SizedBox.square(
      dimension: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: context.colors.onAccent.withValues(
            alpha: AppOpacity.scannerControl,
          ),
          foregroundColor: context.colors.onAccent,
          side: BorderSide(
            color: context.colors.onAccent.withValues(
              alpha: AppOpacity.scannerControl,
            ),
          ),
        ),
        icon: Icon(icon, size: AppSizes.icon),
      ),
    );
  }
}
