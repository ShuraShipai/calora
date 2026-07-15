import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({super.key, required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Trend — last 6 weeks',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkFaint,
              fontWeight: AppFontWeights.bold,
              letterSpacing: AppSpacing.xxs,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CaloraLineChart(
            values: values.isEmpty ? const <double>[0, 0] : values,
            showLastPoint: true,
          ),
        ],
      ),
    );
  }
}
