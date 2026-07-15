import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_text_field.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingDetailsStep extends StatelessWidget {
  const OnboardingDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OnboardingStepHeading(
          title: "Let's set you up",
          subtitle: 'A few basics so Calora can personalise your plan.',
        ),
        OnboardingTextField(
          label: 'Name',
          initialValue: onboarding.name,
          hint: 'Your name',
          onChanged: onboarding.updateName,
          validator: _required('Enter your name.'),
        ),
        OnboardingTextField(
          label: 'Age',
          initialValue: onboarding.age,
          hint: 'e.g. 27',
          keyboardType: TextInputType.number,
          onChanged: onboarding.updateAge,
          validator: _positiveWholeNumber('Enter a valid age.'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: OnboardingTextField(
                label: 'Height',
                initialValue: onboarding.height,
                hint: 'cm',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateHeight,
                validator: _positiveNumber('Enter a valid height.'),
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingTextField(
                label: 'Current weight',
                initialValue: onboarding.currentWeight,
                hint: 'kg',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateCurrentWeight,
                validator: _positiveNumber('Enter a valid weight.'),
              ),
            ),
          ],
        ),
        OnboardingTextField(
          label: 'Target weight',
          initialValue: onboarding.targetWeight,
          hint: 'kg',
          keyboardType: TextInputType.number,
          onChanged: onboarding.updateTargetWeight,
          validator: _positiveNumber('Enter a valid weight.'),
        ),
      ],
    );
  }

  static FormFieldValidator<String> _required(String message) =>
      (value) => value == null || value.trim().isEmpty ? message : null;

  static FormFieldValidator<String> _positiveWholeNumber(String message) =>
      (value) {
        final parsed = int.tryParse(value?.trim() ?? '');
        return parsed == null || parsed <= 0 ? message : null;
      };

  static FormFieldValidator<String> _positiveNumber(String message) => (value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    return parsed == null || parsed <= 0 ? message : null;
  };
}
