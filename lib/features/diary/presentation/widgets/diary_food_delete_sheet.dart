import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class DiaryFoodDeleteSheet extends StatelessWidget {
  const DiaryFoodDeleteSheet({super.key, required this.foodName});

  final String foodName;

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: 'Remove food?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Remove $foodName from today\'s diary?',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Row(
            children: <Widget>[
              Expanded(
                child: CaloraActionButton(
                  label: 'Cancel',
                  style: CaloraActionButtonStyle.secondary,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.error,
                    foregroundColor: context.colors.onAccent,
                  ),
                  child: const Text('Remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
