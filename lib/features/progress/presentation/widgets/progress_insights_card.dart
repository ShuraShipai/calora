import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class ProgressInsightsCard extends StatelessWidget {
  const ProgressInsightsCard({
    super.key,
    required this.calorieProgress,
    required this.calorieGoal,
    required this.averageCalories,
    required this.proteinAverage,
    required this.carbohydrateAverage,
    required this.fatAverage,
    required this.proteinFilled,
    required this.carbohydrateFilled,
    required this.fatFilled,
  });

  final double calorieProgress;
  final int calorieGoal;
  final int averageCalories;
  final int proteinAverage;
  final int carbohydrateAverage;
  final int fatAverage;
  final int proteinFilled;
  final int carbohydrateFilled;
  final int fatFilled;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Daily calorie intake',
                  style: _sectionLabel(context),
                ),
              ),
              Semantics(
                label: 'Swipe left or right to change day',
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.swipe,
                    size: AppSizes.iconSmall,
                    color: context.colors.inkFaint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: CaloraProgressRing(
              value: calorieProgress,
              primaryText: '$averageCalories',
              secondaryText: 'of $calorieGoal kcal',
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.section),
            child: Divider(height: AppStrokes.thin, thickness: AppStrokes.thin),
          ),
          Text('Macro consistency', style: _sectionLabel(context)),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Protein',
            value: 'avg ${proteinAverage}g',
            filled: proteinFilled,
            color: context.colors.protein,
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Carbohydrates',
            value: 'avg ${carbohydrateAverage}g',
            filled: carbohydrateFilled,
            color: context.colors.carb,
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraMacroMeter(
            label: 'Fat',
            value: 'avg ${fatAverage}g',
            filled: fatFilled,
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
