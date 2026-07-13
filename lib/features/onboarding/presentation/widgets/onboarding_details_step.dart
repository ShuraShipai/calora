import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_text_field.dart';
import 'package:flutter/material.dart';

class OnboardingDetailsStep extends StatelessWidget {
  const OnboardingDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OnboardingStepHeading(
          title: "Let's set you up",
          subtitle: 'A few basics so Calora can personalise your plan.',
        ),
        OnboardingTextField(
          label: 'Name',
          initialValue: 'Aanya',
          hint: 'Your name',
        ),
        OnboardingTextField(
          label: 'Age',
          initialValue: '27',
          hint: 'e.g. 27',
          keyboardType: TextInputType.number,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: OnboardingTextField(
                label: 'Height',
                initialValue: '165',
                hint: 'cm',
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingTextField(
                label: 'Current weight',
                initialValue: '68',
                hint: 'kg',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        OnboardingTextField(
          label: 'Target weight',
          initialValue: '60',
          hint: 'kg',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
