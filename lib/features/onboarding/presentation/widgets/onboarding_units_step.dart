import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_calorie_target.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_selection_card.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingUnitsStep extends StatelessWidget {
  const OnboardingUnitsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const OnboardingStepHeading(
          title: 'Preferred units',
          subtitle: 'Used across weight, height and portions.',
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: OnboardingSelectionCard(
                title: 'Metric',
                subtitle: 'kg · cm',
                centered: true,
                selected: onboarding.unitSystem == UnitSystem.metric,
                onTap: () => onboarding.selectUnitSystem(UnitSystem.metric),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingSelectionCard(
                title: 'Imperial',
                subtitle: 'lb · ft/in',
                centered: true,
                selected: onboarding.unitSystem == UnitSystem.imperial,
                onTap: () => onboarding.selectUnitSystem(UnitSystem.imperial),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        const OnboardingStepHeading(
          title: 'Your daily calorie target',
          subtitle:
              'Calculated from your details. You can fine-tune this later.',
          bottomSpacing: AppSpacing.section,
        ),
        const OnboardingCalorieTarget(),
      ],
    );
  }
}
