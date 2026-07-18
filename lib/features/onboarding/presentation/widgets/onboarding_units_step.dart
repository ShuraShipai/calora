import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_selection_card.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_step_heading.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_text_field.dart';
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
          title: 'Finish your plan',
          subtitle:
              'Choose your preferred units, then add the goals you want to track.',
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
          title: 'Remaining goals',
          subtitle: 'Optional. You can also set these anytime in Goals.',
          bottomSpacing: AppSpacing.section,
        ),
        OnboardingTextField(
          label: 'Daily calorie target',
          initialValue: onboarding.dailyCalorieTarget,
          hint: 'kcal',
          keyboardType: TextInputType.number,
          onChanged: onboarding.updateDailyCalorieTarget,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: OnboardingTextField(
                label: 'Protein',
                initialValue: onboarding.proteinGoal,
                hint: 'g',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateProteinGoal,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingTextField(
                label: 'Carbs',
                initialValue: onboarding.carbohydrateGoal,
                hint: 'g',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateCarbohydrateGoal,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingTextField(
                label: 'Fat',
                initialValue: onboarding.fatGoal,
                hint: 'g',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateFatGoal,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: OnboardingTextField(
                label: 'Water goal',
                initialValue: onboarding.waterGoal,
                hint: onboarding.unitSystem == UnitSystem.imperial
                    ? 'fl oz'
                    : 'L',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateWaterGoal,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OnboardingTextField(
                label: 'Weekly weight goal',
                initialValue: onboarding.weeklyWeightGoal,
                hint: onboarding.unitSystem == UnitSystem.imperial
                    ? 'lb / week'
                    : 'kg / week',
                keyboardType: TextInputType.number,
                onChanged: onboarding.updateWeeklyWeightGoal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
