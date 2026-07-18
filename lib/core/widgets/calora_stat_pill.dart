import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/app_typography.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraStatPill extends StatelessWidget {
  const CaloraStatPill({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadii.input),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: AppFontSizes.stat,
              fontFamily: AppTypography.displayFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
