import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/progress/models/progress_date_range.dart';
import 'package:calora/features/progress/models/progress_goal_metrics.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:calora/features/progress/presentation/widgets/progress_page_body.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final diary = context.watch<DiaryProvider>();
    final progress = context.watch<ProgressProvider>();
    final goals = _goalsFor(context.watch<AuthProvider>().profile?.onboarding);
    final dailyRange = ProgressDateRange.day(_selectedDay);
    final trendRange = ProgressDateRange.week(DateTime.now());
    final water = trendRange.days
        .map((day) => _waterFor(progress.waterEntries, day).toDouble())
        .toList();
    final waterMaximum = water.fold<double>(
      0,
      (maximum, value) => value > maximum ? value : maximum,
    );
    final normalizedWater = water
        .map((value) => waterMaximum == 0 ? 0.0 : value / waterMaximum)
        .toList();
    final weights = _weightValues(progress.weightEntries, trendRange);
    final totals = diary.nutritionBetween(dailyRange.start, dailyRange.end);
    final count = dailyRange.dayCount;
    final calorieGoal = _calorieGoal(
      context.watch<AuthProvider>().profile?.onboarding?.dailyCalorieTarget,
    );
    return CaloraScreenScaffold(
      screenId: 'progress',
      body: ProgressPageBody(
        onPreviousDay: _showPreviousDay,
        onNextDay: _selectedDay.isBefore(_startOfToday) ? _showNextDay : null,
        calorieProgress: goals.calorieChartValue(totals.calories),
        calorieGoal: calorieGoal,
        selectedDay: _selectedDay,
        waterValues: normalizedWater,
        weightValues: weights,
        waterLabels: trendRange.weekdayLabels,
        weightLabel: _weightLabel(progress.latestWeight?.weightKg),
        averageCalories: count == 0 ? 0 : (totals.calories / count).round(),
        proteinAverage: count == 0 ? 0 : (totals.protein / count).round(),
        carbohydrateAverage: count == 0 ? 0 : (totals.carbs / count).round(),
        fatAverage: count == 0 ? 0 : (totals.fat / count).round(),
        proteinFilled: goals.proteinSegments(
          count == 0 ? 0 : (totals.protein / count).round(),
        ),
        carbohydrateFilled: goals.carbohydrateSegments(
          count == 0 ? 0 : (totals.carbs / count).round(),
        ),
        fatFilled: goals.fatSegments(
          count == 0 ? 0 : (totals.fat / count).round(),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        selectedTab: MainTab.progress,
      ),
    );
  }

  DateTime get _startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _showPreviousDay() {
    setState(
      () => _selectedDay = _selectedDay.subtract(const Duration(days: 1)),
    );
  }

  void _showNextDay() {
    setState(() => _selectedDay = _selectedDay.add(const Duration(days: 1)));
  }

  int _waterFor(List<WaterEntry> entries, DateTime day) => entries
      .where((entry) => _isSameDay(entry.loggedAt, day))
      .fold(0, (total, entry) => total + entry.amountMl);

  List<double> _weightValues(
    List<WeightEntry> entries,
    ProgressDateRange range,
  ) {
    final beforeRange =
        entries.where((entry) => entry.loggedAt.isBefore(range.start)).toList()
          ..sort((first, second) => first.loggedAt.compareTo(second.loggedAt));
    final inRange =
        entries
            .where(
              (entry) =>
                  !entry.loggedAt.isBefore(range.start) &&
                  entry.loggedAt.isBefore(range.end),
            )
            .toList()
          ..sort((first, second) => first.loggedAt.compareTo(second.loggedAt));
    final measurements = <WeightEntry>[
      if (beforeRange.isNotEmpty) beforeRange.last,
      ...inRange,
    ];
    if (measurements.isEmpty) return const <double>[];
    final values = measurements.map((entry) => entry.weightKg).toList();
    final min = values.reduce(
      (first, second) => first < second ? first : second,
    );
    final max = values.reduce(
      (first, second) => first > second ? first : second,
    );
    if (max == min) {
      return List<double>.filled(values.length, 0.5);
    }
    return values.map((value) => 1 - ((value - min) / (max - min))).toList();
  }

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  String _weightLabel(double? latestWeightKg) => latestWeightKg == null
      ? 'Last 7 days'
      : 'Last 7 days · ${latestWeightKg.toStringAsFixed(1)} kg';

  int _calorieGoal(int? value) => value != null && value > 0
      ? value
      : ProgressGoalMetrics.fallbackDailyCalorieTarget;

  ProgressGoalMetrics _goalsFor(OnboardingDetails? details) =>
      ProgressGoalMetrics(
        dailyCalorieTarget: details?.dailyCalorieTarget,
        proteinGoalGrams: details?.proteinGoalGrams,
        carbohydrateGoalGrams: details?.carbohydrateGoalGrams,
        fatGoalGrams: details?.fatGoalGrams,
      );
}
