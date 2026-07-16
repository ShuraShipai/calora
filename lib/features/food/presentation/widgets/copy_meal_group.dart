import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:flutter/material.dart';

class CopyMealGroup extends StatelessWidget {
  const CopyMealGroup({
    super.key,
    required this.entries,
    required this.copying,
    required this.onCopy,
  });

  final List<DiaryEntry> entries;
  final bool copying;
  final ValueChanged<DiaryEntry> onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const CaloraSectionTitle('Previous meals'),
        CaloraGroupedList(
          children: <Widget>[
            for (final entry in entries)
              CaloraListRow(
                icon: _iconFor(entry.mealType),
                title: entry.mealType.label,
                subtitle: '${entry.name} · ${entry.calories} kcal',
                trailing: TextButton(
                  onPressed: copying ? null : () => onCopy(entry),
                  child: const Text('Copy'),
                ),
              ),
          ],
        ),
      ],
    );
  }

  IconData _iconFor(MealType meal) => switch (meal) {
    MealType.breakfast => Icons.breakfast_dining_outlined,
    MealType.lunch => Icons.rice_bowl_outlined,
    MealType.dinner => Icons.local_pizza_outlined,
    MealType.snacks => Icons.tapas_outlined,
  };
}
