import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/food/models/food_entry.dart';
import 'package:calora/features/food/presentation/widgets/food_entry_row.dart';
import 'package:calora/features/food/presentation/widgets/meal_add_food_button.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onAdd,
    this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  final MealEntries meal;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onEdit;
  final ValueChanged<int>? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: AppRadii.cardBorder,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardBorder,
        child: Column(
          children: <Widget>[
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.section,
                    vertical: AppSpacing.xxl,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: AppSizes.listIcon,
                        height: AppSizes.listIcon,
                        decoration: BoxDecoration(
                          color: context.colors.mossTint,
                          borderRadius: AppRadii.inputBorder,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          _iconFor(meal.label),
                          size: AppFontSizes.sheetTitle,
                          color: context.colors.moss,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              meal.label,
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              meal.entries.isEmpty
                                  ? 'Nothing logged yet'
                                  : '${meal.entries.length} item${meal.entries.length == 1 ? '' : 's'} · ${meal.totalKcal} kcal',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onAdd != null)
                        compact
                            ? CaloraAddButton(onPressed: onAdd!)
                            : MealAddFoodButton(onPressed: onAdd!),
                    ],
                  ),
                ),
              ),
            ),
            if (!compact && meal.entries.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.section),
                child: Text(
                  'Nothing logged yet.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.inkFaint,
                  ),
                ),
              ),
            if (!compact)
              for (var index = 0; index < meal.entries.length; index++)
                FoodEntryRow(
                  entry: meal.entries[index],
                  onEdit: onEdit == null ? null : () => onEdit!(index),
                  onDelete: onDelete == null ? null : () => onDelete!(index),
                ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String label) => switch (label) {
    'Breakfast' => Icons.breakfast_dining_outlined,
    'Lunch' => Icons.rice_bowl_outlined,
    'Dinner' => Icons.local_pizza_outlined,
    _ => Icons.tapas_outlined,
  };
}
