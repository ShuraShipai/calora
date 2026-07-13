import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
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
          child: _DateTimeField(
            label: 'Date',
            value: localizations.formatMediumDate(value),
            icon: Icons.calendar_today_outlined,
            onTap: onSelectDate,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _DateTimeField(
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

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: context.textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      Material(
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputBorder,
          side: BorderSide(color: context.colors.borderStrong),
        ),
        child: InkWell(
          borderRadius: AppRadii.inputBorder,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.input,
            ),
            child: Row(
              children: <Widget>[
                Icon(icon, size: AppSizes.iconSmall),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
