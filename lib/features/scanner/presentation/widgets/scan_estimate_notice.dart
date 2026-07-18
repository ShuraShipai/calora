import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ScanEstimateNotice extends StatelessWidget {
  const ScanEstimateNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: AppRadii.inputBorder,
      ),
      child: Text(
        'Food suggestions come from the photo. Nutrition is calculated after you confirm the food and amount.',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.inkSoft,
        ),
      ),
    );
  }
}
