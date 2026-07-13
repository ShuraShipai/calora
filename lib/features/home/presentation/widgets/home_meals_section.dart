import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/home/presentation/widgets/home_meal_summary_card.dart';
import 'package:flutter/material.dart';

class HomeMealsSection extends StatelessWidget {
  const HomeMealsSection({super.key, required this.diary});

  final DiaryProvider diary;

  @override
  Widget build(BuildContext context) {
    void openDiary() =>
        unawaited(Navigator.pushReplacementNamed(context, AppRoutes.diary));
    void addFood(MealType type) => unawaited(
      Navigator.pushNamed(
        context,
        AppRoutes.addFood,
        arguments: MealSelectionArguments(type),
      ),
    );

    return CaloraSection(
      bottom: AppSpacing.lg,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(child: CaloraSectionTitle("Today's meals")),
              TextButton(onPressed: openDiary, child: const Text('Open diary')),
            ],
          ),
          HomeMealSummaryCard(
            title: 'Breakfast',
            summary: _summaryFor(MealType.breakfast),
            icon: Icons.breakfast_dining_outlined,
            onTap: openDiary,
            onAdd: () => addFood(MealType.breakfast),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeMealSummaryCard(
            title: 'Lunch',
            summary: _summaryFor(MealType.lunch),
            icon: Icons.shopping_bag_outlined,
            onTap: openDiary,
            onAdd: () => addFood(MealType.lunch),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeMealSummaryCard(
            title: 'Dinner',
            summary: _summaryFor(MealType.dinner),
            icon: Icons.dinner_dining_outlined,
            onTap: openDiary,
            onAdd: () => addFood(MealType.dinner),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeMealSummaryCard(
            title: 'Snacks',
            summary: _summaryFor(MealType.snacks),
            icon: Icons.star_outline,
            onTap: openDiary,
            onAdd: () => addFood(MealType.snacks),
          ),
        ],
      ),
    );
  }

  String _summaryFor(MealType type) {
    final entries = diary.entriesFor(DateTime.now(), type);
    if (entries.isEmpty) return 'Nothing logged yet';
    final itemLabel = entries.length == 1 ? 'item' : 'items';
    return '${entries.length} $itemLabel · ${diary.caloriesFor(DateTime.now(), type)} kcal';
  }
}
