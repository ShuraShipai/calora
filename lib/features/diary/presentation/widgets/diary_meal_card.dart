import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:calora/features/diary/presentation/widgets/diary_empty_meal.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_item.dart';
import 'package:calora/features/diary/presentation/widgets/diary_meal_header.dart';
import 'package:flutter/material.dart';

class DiaryMealCard extends StatelessWidget {
  const DiaryMealCard({
    super.key,
    required this.meal,
    this.onAdd,
    this.canManage = false,
  });

  final DiaryMealData meal;
  final VoidCallback? onAdd;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: AppRadii.cardBorder,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardBorder,
        child: Column(
          children: <Widget>[
            DiaryMealHeader(
              title: meal.name,
              summary: meal.summary,
              icon: meal.icon,
              onAdd: onAdd,
            ),
            if (meal.foods.isEmpty)
              const DiaryEmptyMeal()
            else
              for (final food in meal.foods)
                DiaryFoodItem(food: food, canManage: canManage),
          ],
        ),
      ),
    );
  }
}
