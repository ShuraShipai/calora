import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:flutter/material.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key, required this.onEdit, required this.profile});
  final void Function(String title, String value, String unit) onEdit;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final details = profile?.onboarding;
    final unitSystem = details?.unitSystem;
    final waterMl = ((details?.waterGoalLiters ?? 0) * 1000).round();
    final waterValue = MeasurementFormatter.waterFromMillilitres(
      waterMl,
      unitSystem,
    );
    final targetWeight = MeasurementFormatter.weightFromKg(
      details?.targetWeightKg ?? 0,
      unitSystem,
    );
    final weeklyWeight = MeasurementFormatter.weightFromKg(
      details?.weeklyWeightGoalKg ?? 0,
      unitSystem,
    );
    final weightUnit = unitSystem == UnitSystem.imperial ? 'lb' : 'kg';
    final waterUnit = unitSystem == UnitSystem.imperial ? 'fl oz' : 'L';
    return CaloraGroupedList(
      children: <Widget>[
        _row(
          context,
          Icons.eco_outlined,
          '${details?.dailyCalorieTarget ?? 0} kcal',
          'Balances your target weight and activity',
          'Daily calorie goal',
          details?.dailyCalorieTarget?.toString() ?? '',
          'kcal',
        ),
        _row(
          context,
          Icons.crop_square,
          '${details?.proteinGoalGrams ?? 0} g',
          'Supports muscle maintenance',
          'Protein goal',
          details?.proteinGoalGrams?.toString() ?? '',
          'g',
          context.colors.protein,
        ),
        _row(
          context,
          Icons.breakfast_dining_outlined,
          '${details?.carbohydrateGoalGrams ?? 0} g',
          'Your main energy source',
          'Carbohydrate goal',
          details?.carbohydrateGoalGrams?.toString() ?? '',
          'g',
          context.colors.carb,
        ),
        _row(
          context,
          Icons.water_drop_outlined,
          '${details?.fatGoalGrams ?? 0} g',
          'Supports hormones & absorption',
          'Fat goal',
          details?.fatGoalGrams?.toString() ?? '',
          'g',
          context.colors.fat,
        ),
        _row(
          context,
          Icons.water_drop_outlined,
          '${waterValue.toStringAsFixed(1)} $waterUnit',
          'Based on your body weight',
          'Water goal',
          details?.waterGoalLiters == null ? '' : '$waterValue',
          waterUnit,
          context.colors.water,
        ),
        _row(
          context,
          Icons.near_me_outlined,
          '${targetWeight.toStringAsFixed(1)} $weightUnit',
          'Target weight',
          'Target weight',
          details?.targetWeightKg == null ? '' : '$targetWeight',
          weightUnit,
        ),
        _row(
          context,
          Icons.horizontal_rule,
          '${weeklyWeight.toStringAsFixed(1)} $weightUnit / week',
          'A gentle, sustainable pace',
          'Weekly weight goal',
          details?.weeklyWeightGoalKg == null ? '' : '$weeklyWeight',
          '$weightUnit / week',
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
