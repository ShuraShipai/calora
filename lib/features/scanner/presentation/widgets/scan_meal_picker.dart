import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class ScanMealPicker extends StatelessWidget {
  const ScanMealPicker({
    super.key,
    required this.meal,
    required this.onChanged,
  });

  final String meal;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Meal', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final value in const <String>[
                'Breakfast',
                'Lunch',
                'Dinner',
                'Snack',
              ]) ...<Widget>[
                CaloraChoiceChip(
                  label: value,
                  selected: meal == value,
                  onTap: () => onChanged(value),
                ),
                if (value != 'Snack') const SizedBox(width: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
