import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class DiaryEmptyMeal extends StatelessWidget {
  const DiaryEmptyMeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      alignment: Alignment.center,
      child: Text(
        'Nothing logged yet.',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.inkSoft,
        ),
      ),
    );
  }
}
