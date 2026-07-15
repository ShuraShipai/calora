import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/food/presentation/widgets/custom_food_date_time_field.dart';
import 'package:flutter/material.dart';

class CustomFoodDateTimeFields extends StatelessWidget {
  const CustomFoodDateTimeFields({
    super.key,
    required this.value,
    required this.onSelectDate,
    required this.onSelectTime,
  });

  final DateTime value;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomFoodDateTimeField(
            label: 'Date',
            value: localizations.formatMediumDate(value),
            icon: Icons.calendar_today_outlined,
            onTap: onSelectDate,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: CustomFoodDateTimeField(
            label: 'Time',
            value: localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value)),
            icon: Icons.access_time_outlined,
            onTap: onSelectTime,
          ),
        ),
      ],
    );
  }
}
