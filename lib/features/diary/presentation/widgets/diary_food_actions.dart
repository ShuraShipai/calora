import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class DiaryFoodActions extends StatelessWidget {
  const DiaryFoodActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ActionButton(
          tooltip: 'Edit food',
          icon: Icons.edit_outlined,
          onPressed: onEdit,
        ),
        const SizedBox(width: AppSpacing.xs),
        _ActionButton(
          tooltip: 'Remove food',
          icon: Icons.delete_outline,
          color: context.colors.error,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x4,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          foregroundColor: color ?? context.colors.inkSoft,
          backgroundColor: context.colors.surface,
          side: BorderSide(color: context.colors.border),
        ),
        icon: Icon(icon, size: AppSizes.iconSmall),
      ),
    );
  }
}
