import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:flutter/material.dart';

class DiaryFoodItem extends StatelessWidget {
  const DiaryFoodItem({super.key, required this.food});

  final DiaryFoodData food;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.border)),
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
          ],
        ),
      ),
    );
  }
}
