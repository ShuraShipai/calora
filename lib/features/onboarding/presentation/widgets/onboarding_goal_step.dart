import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_selection_card.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingGoalStep extends StatelessWidget {
  const OnboardingGoalStep({super.key});

  static const _options = <(String, String, IconData)>[
    ('Lose weight', 'Gentle, sustainable deficit', Icons.navigation_outlined),
    (
      'Maintain weight',
      'Stay steady where you are',
      Icons.track_changes_outlined,
    ),
    ('Gain weight', 'Build up with a surplus', Icons.arrow_upward),
    ('Improve nutrition', 'Better balanced meals', Icons.eco_outlined),
    ('Build healthy habits', 'Small consistent changes', Icons.check),
  ];

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const OnboardingStepHeading(
          title: 'Your main goal',
          subtitle: 'You can change this anytime in Goals.',
        ),
        for (var index = 0; index < _options.length; index++) ...<Widget>[
          OnboardingSelectionCard(
            title: _options[index].$1,
            subtitle: _options[index].$2,
            icon: _options[index].$3,
            selected: onboarding.goal == WellnessGoal.values[index],
            onTap: () => onboarding.selectGoal(WellnessGoal.values[index]),
          ),
          if (index != _options.length - 1)
            const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}
