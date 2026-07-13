import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class ProgressTrendsCard extends StatelessWidget {
  const ProgressTrendsCard({super.key, required this.onWeightPressed});

  final VoidCallback onWeightPressed;

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
                const CaloraLineChart(
                  values: <double>[0, 0, 0, 0, 0, 0, 0],
                  height: AppSizes.chart,
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
                  values: const <double>[0, 0, 0, 0, 0, 0, 0],
                  color: context.colors.water,
                  highlighted: const <int>{0, 1, 2, 3, 4, 5, 6},
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
