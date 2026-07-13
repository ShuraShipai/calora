import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

enum CaloraActionButtonStyle { primary, secondary, ghost }

class CaloraActionButton extends StatelessWidget {
  const CaloraActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = CaloraActionButtonStyle.primary,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final CaloraActionButtonStyle style;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox.square(
            dimension: AppSpacing.sectionGap,
            child: CircularProgressIndicator(
              strokeWidth: AppStrokes.scanner,
              color: style == CaloraActionButtonStyle.primary
                  ? context.colors.onAccent
                  : context.colors.moss,
            ),
          )
        : Text(label);
    final callback = isLoading ? null : onPressed;
    final button = switch (style) {
      CaloraActionButtonStyle.primary => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadii.pillBorder,
          boxShadow: callback == null ? null : context.shadows.primaryButton,
        ),
        child: FilledButton(onPressed: callback, child: child),
      ),
      CaloraActionButtonStyle.secondary => OutlinedButton(
        onPressed: callback,
        child: child,
      ),
      CaloraActionButtonStyle.ghost => TextButton(
        onPressed: callback,
        child: child,
      ),
    };

    return SizedBox(
      width: expand ? double.infinity : null,
      height: AppSizes.actionButtonHeight,
      child: button,
    );
  }
}
