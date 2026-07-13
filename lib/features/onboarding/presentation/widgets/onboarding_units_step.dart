import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_calorie_target.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_selection_card.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:flutter/material.dart';

class OnboardingUnitsStep extends StatefulWidget {
  const OnboardingUnitsStep({super.key});

  @override
  State<OnboardingUnitsStep> createState() => _OnboardingUnitsStepState();
}

class _OnboardingUnitsStepState extends State<OnboardingUnitsStep> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
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
                selected: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingSelectionCard(
                title: 'Imperial',
                subtitle: 'lb · ft/in',
                centered: true,
                selected: _selected == 1,
                onTap: () => setState(() => _selected = 1),
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
