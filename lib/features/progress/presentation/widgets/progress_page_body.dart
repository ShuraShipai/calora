import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/progress/presentation/widgets/progress_insights_card.dart';
import 'package:calora/features/progress/presentation/widgets/progress_trends_card.dart';
import 'package:flutter/material.dart';

class ProgressPageBody extends StatelessWidget {
  const ProgressPageBody({
    super.key,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.calorieProgress,
    required this.calorieGoal,
    required this.weightValues,
    required this.waterValues,
    required this.waterLabels,
    required this.weightLabel,
    required this.averageCalories,
    required this.proteinAverage,
    required this.carbohydrateAverage,
    required this.fatAverage,
    required this.proteinFilled,
    required this.carbohydrateFilled,
    required this.fatFilled,
  });

  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final double calorieProgress;
  final int calorieGoal;
  final List<double> weightValues;
  final List<double> waterValues;
  final List<String> waterLabels;
  final String weightLabel;
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
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: _DailyCalorieSwipeDetector(
            key: const ValueKey<String>('daily-calorie-swipe'),
            onPreviousDay: onPreviousDay,
            onNextDay: onNextDay,
            child: ProgressInsightsCard(
              calorieProgress: calorieProgress,
              calorieGoal: calorieGoal,
              averageCalories: averageCalories,
              proteinAverage: proteinAverage,
              carbohydrateAverage: carbohydrateAverage,
              fatAverage: fatAverage,
              proteinFilled: proteinFilled,
              carbohydrateFilled: carbohydrateFilled,
              fatFilled: fatFilled,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressTrendsCard(
            weightValues: weightValues,
            waterValues: waterValues,
            labels: waterLabels,
            weightLabel: weightLabel,
          ),
        ),
      ],
    );
  }
}

class _DailyCalorieSwipeDetector extends StatefulWidget {
  const _DailyCalorieSwipeDetector({
    super.key,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.child,
  });

  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final Widget child;

  @override
  State<_DailyCalorieSwipeDetector> createState() =>
      _DailyCalorieSwipeDetectorState();
}

class _DailyCalorieSwipeDetectorState
    extends State<_DailyCalorieSwipeDetector> {
  double _dragDistance = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onHorizontalDragUpdate: (details) {
      _dragDistance += details.primaryDelta ?? 0;
    },
    onHorizontalDragCancel: _reset,
    onHorizontalDragEnd: (_) {
      if (_dragDistance > 48) widget.onPreviousDay();
      if (_dragDistance < -48) widget.onNextDay?.call();
      _reset();
    },
    child: widget.child,
  );

  void _reset() => _dragDistance = 0;
}
