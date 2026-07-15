import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_selection_card.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingActivityStep extends StatelessWidget {
  const OnboardingActivityStep({super.key});

  static const _options = <(String, String, IconData)>[
    ('Sedentary', 'Little to no exercise', Icons.chair_outlined),
    ('Lightly active', '1–3 workouts / week', Icons.bolt_outlined),
    ('Active', '4–5 workouts / week', Icons.monitor_heart_outlined),
    ('Very active', 'Daily training', Icons.star_border),
  ];

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const OnboardingStepHeading(
          title: 'Your activity level',
          subtitle: 'This helps set an accurate calorie target.',
        ),
        for (var index = 0; index < _options.length; index++) ...<Widget>[
          OnboardingSelectionCard(
            title: _options[index].$1,
            subtitle: _options[index].$2,
            icon: _options[index].$3,
            selected: onboarding.activityLevel == ActivityLevel.values[index],
            onTap: () => onboarding.selectActivity(ActivityLevel.values[index]),
          ),
          if (index != _options.length - 1)
            const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}
