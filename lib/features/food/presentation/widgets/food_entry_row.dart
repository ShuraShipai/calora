import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/food/models/food_entry.dart';
import 'package:flutter/material.dart';

class FoodEntryRow extends StatelessWidget {
  const FoodEntryRow({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  final FoodEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.section,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: AppSizes.foodThumbnail,
            height: AppSizes.foodThumbnail,
            decoration: BoxDecoration(
              color: context.colors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadii.thumbnail),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.circle_outlined,
              size: AppSizes.icon,
              color: context.colors.inkFaint,
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
                Text(
                  '${entry.serving} · P ${entry.protein}g · C ${entry.carbs}g · F ${entry.fat}g',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text('${entry.kcal}', style: context.textTheme.labelMedium),
          if (onEdit != null) ...<Widget>[
            const SizedBox(width: AppSpacing.md),
            IconButton(
              tooltip: 'Edit food',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: AppSizes.iconSmall),
            ),
          ],
          if (onDelete != null)
            IconButton(
              tooltip: 'Remove food',
              onPressed: onDelete,
              color: context.colors.error,
              icon: const Icon(Icons.delete_outline, size: AppSizes.iconSmall),
            ),
        ],
      ),
    );
  }
}
