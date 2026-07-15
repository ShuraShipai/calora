import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:flutter/material.dart';

class MealLabelSuggestions extends StatelessWidget {
  const MealLabelSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  final List<MealLabelSuggestion> suggestions;
  final ValueChanged<MealLabelSuggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CaloraSectionTitle('Food suggestions'),
        Text(
          'Choose a suggestion, then confirm the amount for nutrition.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.inkSoft,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            for (final suggestion in suggestions)
              ActionChip(
                label: Text(suggestion.label),
                onPressed: () => onSelected(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}
