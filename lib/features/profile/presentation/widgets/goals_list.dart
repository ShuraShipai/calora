import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:flutter/material.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key, required this.onEdit, required this.profile});
  final void Function(String title, String value, String unit) onEdit;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final details = profile?.onboarding;
    return CaloraGroupedList(
      children: <Widget>[
        _row(
          context,
          Icons.eco_outlined,
          '${details?.dailyCalorieTarget ?? 0} kcal',
          'Balances your target weight and activity',
          'Daily calorie goal',
          '${details?.dailyCalorieTarget ?? 0}',
          'kcal',
        ),
        _row(
          context,
          Icons.crop_square,
          '${details?.proteinGoalGrams ?? 0} g',
          'Supports muscle maintenance',
          'Protein goal',
          '${details?.proteinGoalGrams ?? 0}',
          'g',
          context.colors.protein,
        ),
        _row(
          context,
          Icons.breakfast_dining_outlined,
          '${details?.carbohydrateGoalGrams ?? 0} g',
          'Your main energy source',
          'Carbohydrate goal',
          '${details?.carbohydrateGoalGrams ?? 0}',
          'g',
          context.colors.carb,
        ),
        _row(
          context,
          Icons.water_drop_outlined,
          '${details?.fatGoalGrams ?? 0} g',
          'Supports hormones & absorption',
          'Fat goal',
          '${details?.fatGoalGrams ?? 0}',
          'g',
          context.colors.fat,
        ),
        _row(
          context,
          Icons.water_drop_outlined,
          '${details?.waterGoalLiters ?? 0} L',
          'Based on your body weight',
          'Water goal',
          '${details?.waterGoalLiters ?? 0}',
          'L',
          context.colors.water,
        ),
        _row(
          context,
          Icons.near_me_outlined,
          '${details?.targetWeightKg ?? 0} kg',
          'Target weight',
          'Target weight',
          '${details?.targetWeightKg ?? 0}',
          'kg',
        ),
        _row(
          context,
          Icons.horizontal_rule,
          '${details?.weeklyWeightGoalKg ?? 0} kg / week',
          'A gentle, sustainable pace',
          'Weekly weight goal',
          '${details?.weeklyWeightGoalKg ?? 0}',
          'kg / week',
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String value,
    String subtitle,
    String title,
    String editValue,
    String unit, [
    Color? color,
  ]) => CaloraListRow(
    icon: icon,
    iconColor: color ?? context.colors.inkSoft,
    title: value,
    subtitle: subtitle,
    trailing: SizedBox.square(
      dimension: AppSizes.iconButton,
      child: IconButton(
        tooltip: 'Edit $title',
        onPressed: () => onEdit(title, editValue, unit),
        icon: const Icon(Icons.edit_outlined, size: AppSizes.iconSmall),
      ),
    ),
  );
}
