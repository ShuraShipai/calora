import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class ProgressInsightsCard extends StatelessWidget {
  const ProgressInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Daily calorie intake', style: _sectionLabel(context)),
          const SizedBox(height: AppSpacing.lg),
          const CaloraBarChart(
            values: <double>[0, 0, 0, 0, 0, 0, 0],
            highlighted: <int>{},
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Weekly average',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
              Text(
                '0 kcal',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: AppFontWeights.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.section),
            child: Divider(height: AppStrokes.thin, thickness: AppStrokes.thin),
          ),
          Text('Macro consistency', style: _sectionLabel(context)),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Protein',
            value: 'No data',
            filled: 0,
            color: context.colors.protein,
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Carbohydrates',
            value: 'No data',
            filled: 0,
            color: context.colors.carb,
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Fat',
            value: 'No data',
            filled: 0,
            color: context.colors.fat,
          ),
        ],
      ),
    );
  }

  TextStyle? _sectionLabel(BuildContext context) =>
      context.textTheme.labelSmall?.copyWith(
        color: context.colors.inkFaint,
        fontWeight: AppFontWeights.bold,
        letterSpacing: AppSpacing.xxs,
      );
}
