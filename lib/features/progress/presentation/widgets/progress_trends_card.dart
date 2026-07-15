import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class ProgressTrendsCard extends StatelessWidget {
  const ProgressTrendsCard({
    super.key,
    required this.onWeightPressed,
    required this.weightValues,
    required this.waterValues,
    required this.labels,
  });

  final VoidCallback onWeightPressed;
  final List<double> weightValues;
  final List<double> waterValues;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'View weight progress',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onWeightPressed,
          borderRadius: AppRadii.cardBorder,
          child: CaloraCard(
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.section),
                  child: Divider(
                    height: AppStrokes.thin,
                    thickness: AppStrokes.thin,
                  ),
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
          ),
        ),
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
