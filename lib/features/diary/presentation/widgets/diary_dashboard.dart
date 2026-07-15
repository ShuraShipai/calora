import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:calora/features/diary/presentation/widgets/diary_day_section.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:flutter/material.dart';

class DiaryDashboard extends StatelessWidget {
  const DiaryDashboard({super.key, required this.diary});
  final DiaryProvider diary;

  @override
  Widget build(BuildContext context) {
    final dates =
        diary.entries
            .map((entry) => DateUtils.dateOnly(entry.loggedAt))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));
    final today = DateUtils.dateOnly(DateTime.now());
    if (!dates.any((date) => DateUtils.isSameDay(date, today))) {
      dates.insert(0, today);
    }
    return Column(
      children: <Widget>[
        CaloraSection(
          child: CaloraCard(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CaloraStatPill(
                    value: '${diary.caloriesToday}',
                    label: 'Kcal',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CaloraStatPill(
                    value: '${diary.proteinToday}g',
                    label: 'Protein',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CaloraStatPill(
                    value: '${diary.carbsToday}g',
                    label: 'Carbs',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CaloraStatPill(
                    value: '${diary.fatToday}g',
                    label: 'Fat',
                  ),
                ),
              ],
            ),
          ),
        ),
        for (final date in dates)
          CaloraSection(
            bottom: AppSpacing.sectionGap,
            child: DiaryDaySection(day: _dayFor(date, today)),
          ),
      ],
    );
  }

  DiaryDayData _dayFor(DateTime date, DateTime today) => DiaryDayData(
    label: DateUtils.isSameDay(date, today)
        ? 'Today'
        : '${date.day}/${date.month}/${date.year}',
    meals: <DiaryMealData>[
      for (final type in MealType.values) _mealFor(date, type),
    ],
    canAdd: DateUtils.isSameDay(date, today),
  );
  DiaryMealData _mealFor(DateTime date, MealType type) {
    final entries = diary.entriesFor(date, type);
    final calories = entries.fold(0, (sum, entry) => sum + entry.calories);
    return DiaryMealData(
      name: type.label,
      summary: entries.isEmpty
          ? 'Nothing logged yet'
          : '${entries.length} item${entries.length == 1 ? '' : 's'} · $calories kcal',
      icon: _icon(type),
      foods: entries.map(_food).toList(),
    );
  }

  DiaryFoodData _food(DiaryEntry entry) => DiaryFoodData(
    name: entry.name,
    details:
        '${entry.serving} · P ${entry.protein}g · C ${entry.carbs}g · F ${entry.fat}g',
    calories: '${entry.calories}',
    entry: entry,
  );
  IconData _icon(MealType type) => switch (type) {
    MealType.breakfast => Icons.wb_sunny_outlined,
    MealType.lunch => Icons.shopping_bag_outlined,
    MealType.dinner => Icons.dinner_dining_outlined,
    MealType.snacks => Icons.star_border,
  };
}
