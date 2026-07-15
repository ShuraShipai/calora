import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:calora/features/diary/presentation/widgets/diary_meal_card.dart';
import 'package:flutter/material.dart';

class DiaryDaySection extends StatelessWidget {
  const DiaryDaySection({super.key, required this.day});

  final DiaryDayData day;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CaloraSectionTitle(day.label),
        for (var index = 0; index < day.meals.length; index++) ...<Widget>[
          DiaryMealCard(
            meal: day.meals[index],
            canManage: day.canManage,
            onAdd: day.canAdd
                ? () => unawaited(
                    Navigator.pushNamed(
                      context,
                      AppRoutes.addFood,
                      arguments: MealSelectionArguments(
                        MealTypeX.fromStored(day.meals[index].name),
                      ),
                    ),
                  )
                : null,
          ),
          if (index != day.meals.length - 1)
            const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}
