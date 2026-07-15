import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingCalorieTarget extends StatelessWidget {
  const OnboardingCalorieTarget({super.key});

  @override
  Widget build(BuildContext context) {
    final target = context.watch<OnboardingProvider>().dailyCalorieTarget;
    return CaloraCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: <Widget>[
          Text(
            target?.toString() ?? '—',
            style: context.textTheme.displayLarge,
          ),
          Text(
            target == null ? 'Set after your details' : 'calories / day',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
