import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/progress/presentation/widgets/progress_filter_chips.dart';
import 'package:calora/features/progress/presentation/widgets/progress_insights_card.dart';
import 'package:calora/features/progress/presentation/widgets/progress_trends_card.dart';
import 'package:flutter/material.dart';

class ProgressPageBody extends StatelessWidget {
  const ProgressPageBody({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.calorieValues,
    required this.weightValues,
    required this.waterValues,
    required this.labels,
    required this.averageCalories,
    required this.proteinAverage,
    required this.carbohydrateAverage,
    required this.fatAverage,
    required this.proteinFilled,
    required this.carbohydrateFilled,
    required this.fatFilled,
  });

  final int selectedFilter;
  final ValueChanged<int> onFilterSelected;
  final List<double> calorieValues;
  final List<double> weightValues;
  final List<double> waterValues;
  final List<String> labels;
  final int averageCalories;
  final int proteinAverage;
  final int carbohydrateAverage;
  final int fatAverage;
  final int proteinFilled;
  final int carbohydrateFilled;
  final int fatFilled;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Text('Progress', style: context.textTheme.titleLarge),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressFilterChips(
            selectedIndex: selectedFilter,
            onSelected: onFilterSelected,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressInsightsCard(
            calorieValues: calorieValues,
            labels: labels,
            averageCalories: averageCalories,
            proteinAverage: proteinAverage,
            carbohydrateAverage: carbohydrateAverage,
            fatAverage: fatAverage,
            proteinFilled: proteinFilled,
            carbohydrateFilled: carbohydrateFilled,
            fatFilled: fatFilled,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressTrendsCard(
            weightValues: weightValues,
            waterValues: waterValues,
            labels: labels,
          ),
        ),
      ],
    );
  }
}
