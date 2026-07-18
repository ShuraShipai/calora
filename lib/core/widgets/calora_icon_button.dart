import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraIconButton extends StatelessWidget {
  const CaloraIconButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = AppSizes.iconButton,
    this.iconSize = AppSizes.icon,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colors.surface,
          foregroundColor: color ?? context.colors.ink,
          side: BorderSide(color: context.colors.border),
          shadowColor: context.shadows.small.first.color,
          elevation: AppElevations.low,
        ),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}
