import 'package:calora/app/router/app_routes.dart';
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
  var _selectedFilter = 1;
  ProgressDateRange? _customRange;

  @override
  Widget build(BuildContext context) {
    final diary = context.watch<DiaryProvider>();
    final progress = context.watch<ProgressProvider>();
    final goals = _goalsFor(context.watch<AuthProvider>().profile?.onboarding);
    final range = _rangeForFilter(DateTime.now());
    final days = range.days;
    final calories = days
        .map((day) => diary.nutritionFor(day).calories.toDouble())
        .toList();
    final normalizedCalories = calories
        .map((value) => goals.calorieChartValue(value.round()))
        .toList();
    final water = days
        .map((day) => _waterFor(progress.waterEntries, day).toDouble())
        .toList();
    final waterMaximum = water.fold<double>(
      0,
      (maximum, value) => value > maximum ? value : maximum,
    );
    final normalizedWater = water
        .map((value) => waterMaximum == 0 ? 0.0 : value / waterMaximum)
        .toList();
    final weights = _weightValues(progress.weightEntries, range);
    final totals = diary.nutritionBetween(range.start, range.end);
    final count = days.length;
    return CaloraScreenScaffold(
      screenId: 'progress',
      body: ProgressPageBody(
        selectedFilter: _selectedFilter,
        onFilterSelected: _selectFilter,
        onWeightPressed: () => Navigator.pushNamed(context, AppRoutes.weight),
        calorieValues: normalizedCalories,
        waterValues: normalizedWater,
        weightValues: weights,
        labels: _labelsFor(range),
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

  ProgressDateRange _rangeForFilter(DateTime now) {
    switch (_selectedFilter) {
      case 0:
        return ProgressDateRange.day(now);
      case 1:
        return ProgressDateRange.week(now);
      case 2:
        return ProgressDateRange.month(now);
      case 3:
        return ProgressDateRange.threeMonths(now);
      case 4:
        return _customRange ?? ProgressDateRange.week(now);
      default:
        return ProgressDateRange.week(now);
    }
  }

  Future<void> _selectFilter(int index) async {
    if (index != 4) {
      setState(() => _selectedFilter = index);
      return;
    }
    final today = DateTime.now();
    final selection = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: today,
      initialDateRange: _customRange == null
          ? DateTimeRange(
              start: today.subtract(const Duration(days: 6)),
              end: today,
            )
          : DateTimeRange(
              start: _customRange!.start,
              end: _customRange!.end.subtract(const Duration(days: 1)),
            ),
    );
    if (!mounted || selection == null) return;
    setState(() {
      _selectedFilter = index;
      _customRange = ProgressDateRange(
        DateTime(
          selection.start.year,
          selection.start.month,
          selection.start.day,
        ),
        DateTime(
          selection.end.year,
          selection.end.month,
          selection.end.day + 1,
        ),
      );
    });
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

  List<String> _labelsFor(ProgressDateRange range) => switch (_selectedFilter) {
    1 => range.weekdayLabels,
    3 || 4 => range.compactDateLabels,
    _ => range.dayOfMonthLabels,
  };

  ProgressGoalMetrics _goalsFor(OnboardingDetails? details) =>
      ProgressGoalMetrics(
        dailyCalorieTarget: details?.dailyCalorieTarget,
        proteinGoalGrams: details?.proteinGoalGrams,
        carbohydrateGoalGrams: details?.carbohydrateGoalGrams,
        fatGoalGrams: details?.fatGoalGrams,
      );
}
