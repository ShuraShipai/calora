import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:flutter/material.dart';

class HomeCalorieSummary extends StatelessWidget {
  const HomeCalorieSummary({super.key, required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      padding: const EdgeInsets.all(AppSpacing.page),
      child: Column(
        children: <Widget>[
          CaloraProgressRing(
            value: dashboard.calorieProgress,
            primaryText: '${dashboard.caloriesEaten}',
            secondaryText: 'of ${dashboard.calorieGoal} kcal',
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: <Widget>[
              Expanded(
                child: CaloraStatPill(
                  value: '${dashboard.calorieGoal}',
                  label: 'Goal',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CaloraStatPill(
                  value: '${dashboard.caloriesEaten}',
                  label: 'Eaten',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CaloraStatPill(
                  value: '${dashboard.caloriesRemaining}',
                  label: 'Remaining',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
