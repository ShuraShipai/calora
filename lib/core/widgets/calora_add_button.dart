import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraAddButton extends StatelessWidget {
  const CaloraAddButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Add',
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.addButton,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: context.colors.surfaceAlt,
          foregroundColor: context.colors.moss,
          side: BorderSide(color: context.colors.border),
        ),
        icon: const Icon(Icons.add, size: AppSizes.iconSmall),
      ),
    );
  }
}
