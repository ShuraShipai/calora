import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_actions.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_delete_sheet.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_details_sheet.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/food/models/custom_food_edit_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryFoodItem extends StatelessWidget {
  const DiaryFoodItem({super.key, required this.food, this.canManage = false});

  final DiaryFoodData food;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => unawaited(
            showCaloraSheet<void>(
              context: context,
              showDragHandle: false,
              cardStyle: true,
              builder: (_) => DiaryFoodDetailsSheet(entry: food.entry),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.section,
              vertical: AppSpacing.lg,
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
                    color: context.colors.inkFaint,
                    size: AppSizes.icon,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        food.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      Text(
                        food.details,
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
                Text(
                  food.calories,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                if (canManage) ...<Widget>[
                  const SizedBox(width: AppSpacing.md),
                  DiaryFoodActions(
                    onEdit: () => _edit(context),
                    onDelete: () => unawaited(_delete(context)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _edit(BuildContext context) {
    unawaited(
      Navigator.pushNamed(
        context,
        AppRoutes.customFood,
        arguments: CustomFoodEditArguments(food.entry),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showCaloraSheet<bool>(
      context: context,
      showDragHandle: false,
      cardStyle: true,
      builder: (_) => DiaryFoodDeleteSheet(foodName: food.name),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await context.read<DiaryProvider>().remove(food.entry.id);
    } on Object {
      if (context.mounted) {
        showCaloraMessage(context, 'Could not remove diary entry.');
      }
    }
  }
}
