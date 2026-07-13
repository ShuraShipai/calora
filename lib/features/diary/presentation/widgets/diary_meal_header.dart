import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class DiaryMealHeader extends StatelessWidget {
  const DiaryMealHeader({
    super.key,
    required this.title,
    required this.summary,
    required this.icon,
    this.onAdd,
  });

  final String title;
  final String summary;
  final IconData icon;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              borderRadius: BorderRadius.circular(AppRadii.input),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: context.colors.moss,
              size: AppFontSizes.sheetTitle,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: context.textTheme.titleMedium),
                Text(
                  summary,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          if (onAdd != null)
            OutlinedButton.icon(
              onPressed: onAdd,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.moss,
                backgroundColor: context.colors.surfaceAlt,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                visualDensity: VisualDensity.compact,
                minimumSize: Size.zero,
                side: BorderSide(color: context.colors.border),
                shape: const StadiumBorder(),
                textStyle: context.textTheme.labelMedium?.copyWith(
                  fontWeight: AppFontWeights.bold,
                ),
              ),
              icon: const Icon(Icons.add, size: AppSizes.iconSmall),
              label: const Text('Add food'),
            ),
        ],
      ),
    );
  }
}
