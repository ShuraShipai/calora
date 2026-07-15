import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CopyMealEmptyState extends StatelessWidget {
  const CopyMealEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.section),
    child: Column(
      children: <Widget>[
        Icon(Icons.history_outlined, color: context.colors.inkFaint),
        const SizedBox(height: AppSpacing.md),
        Text('No previous meals to copy.', style: context.textTheme.bodyMedium),
      ],
    ),
  );
}
