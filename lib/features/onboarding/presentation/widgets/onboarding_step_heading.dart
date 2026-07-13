import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class OnboardingStepHeading extends StatelessWidget {
  const OnboardingStepHeading({
    super.key,
    required this.title,
    required this.subtitle,
    this.bottomSpacing = AppSpacing.page,
  });

  final String title;
  final String subtitle;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: context.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: AppFontSizes.bodySmall,
            color: context.colors.inkSoft,
          ),
        ),
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}
