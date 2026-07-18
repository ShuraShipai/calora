import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

part 'diary_food_action_button.dart';

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
        _DiaryFoodActionButton(
          tooltip: 'Edit food',
          icon: Icons.edit_outlined,
          onPressed: onEdit,
        ),
        const SizedBox(width: AppSpacing.xs),
        _DiaryFoodActionButton(
          tooltip: 'Remove food',
          icon: Icons.delete_outline,
          color: context.colors.error,
          onPressed: onDelete,
        ),
      ],
    );
  }
}
