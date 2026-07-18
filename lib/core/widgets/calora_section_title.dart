import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraSectionTitle extends StatelessWidget {
  const CaloraSectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colors.inkSoft,
        ),
      ),
    );
  }
}
