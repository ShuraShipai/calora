import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class HomeMealSummaryCard extends StatelessWidget {
  const HomeMealSummaryCard({
    super.key,
    required this.title,
    required this.summary,
    required this.icon,
    required this.onTap,
    required this.onAdd,
  });

  final String title;
  final String summary;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
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
              SizedBox.square(
                dimension: AppSizes.addButton,
                child: IconButton(
                  tooltip: 'Add food to $title',
                  padding: EdgeInsets.zero,
                  onPressed: onAdd,
                  style: IconButton.styleFrom(
                    foregroundColor: context.colors.moss,
                    backgroundColor: context.colors.surfaceAlt,
                    side: BorderSide(color: context.colors.border),
                  ),
                  icon: const Icon(Icons.add, size: AppFontSizes.input),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
