import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:flutter/material.dart';

class HomeCalorieSummary extends StatelessWidget {
  const HomeCalorieSummary({
    super.key,
    required this.dashboard,
    required this.dailyGoals,
  });

  final HomeDashboard dashboard;
  final List<DailyGoalStatus> dailyGoals;

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
          const SizedBox(height: AppSpacing.section),
          const Divider(height: AppStrokes.thin, thickness: AppStrokes.thin),
          const SizedBox(height: AppSpacing.section),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DAILY GOALS',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colors.inkFaint,
                fontWeight: AppFontWeights.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (dailyGoals.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Set a goal in Profile to track it here.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkFaint,
                ),
              ),
            )
          else
            for (final goal in dailyGoals)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: <Widget>[
                    Icon(
                      goal.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: AppSizes.iconSmall,
                      color: goal.isCompleted
                          ? context.colors.moss
                          : context.colors.inkFaint,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      goal.name,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: goal.isCompleted
                            ? context.colors.moss
                            : context.colors.ink,
                        fontWeight: goal.isCompleted
                            ? AppFontWeights.semiBold
                            : AppFontWeights.regular,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
