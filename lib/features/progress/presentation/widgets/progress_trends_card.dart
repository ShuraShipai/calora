import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class ProgressTrendsCard extends StatelessWidget {
  const ProgressTrendsCard({
    super.key,
    required this.weightValues,
    required this.waterValues,
    required this.labels,
    required this.weightLabel,
  });

  final List<double> weightValues;
  final List<double> waterValues;
  final List<String> labels;
  final String weightLabel;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Weight progress', style: _sectionLabel(context)),
          const SizedBox(height: AppSpacing.lg),
          CaloraLineChart(
            values: weightValues,
            height: AppSizes.chart,
            showLastPoint: weightValues.isNotEmpty,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            weightLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.section),
            child: Divider(height: AppStrokes.thin, thickness: AppStrokes.thin),
          ),
          Text('Water intake', style: _sectionLabel(context)),
          const SizedBox(height: AppSpacing.lg),
          CaloraBarChart(
            values: waterValues,
            labels: labels,
            color: context.colors.water,
            highlighted: Set<int>.from(
              List<int>.generate(waterValues.length, (index) => index),
            ),
            height: AppSizes.compactChart,
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
