import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({super.key});

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
          const CaloraLineChart(
            values: <double>[0, 0, 0, 0, 0, 0, 0],
            showLastPoint: true,
          ),
        ],
      ),
    );
  }
}
