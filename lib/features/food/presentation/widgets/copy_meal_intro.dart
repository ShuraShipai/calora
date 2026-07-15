import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CopyMealIntro extends StatelessWidget {
  const CopyMealIntro({super.key});

  @override
  Widget build(BuildContext context) => Text(
    "Pick a meal you've logged before to add it to today's diary.",
    style: context.textTheme.labelMedium?.copyWith(
      color: context.colors.inkSoft,
    ),
  );
}
