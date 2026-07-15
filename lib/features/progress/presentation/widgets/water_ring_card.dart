import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class WaterRingCard extends StatelessWidget {
  const WaterRingCard({
    super.key,
    required this.amountLabel,
    required this.goalLabel,
    required this.progress,
  });

  final String amountLabel;
  final String goalLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      padding: const EdgeInsets.all(AppSpacing.loose),
      child: Center(
        child: CaloraProgressRing(
          value: progress,
          primaryText: amountLabel,
          secondaryText: goalLabel,
          size: AppSizes.waterRing,
          stroke: AppSpacing.input,
          color: context.colors.water,
        ),
      ),
    );
  }
}
