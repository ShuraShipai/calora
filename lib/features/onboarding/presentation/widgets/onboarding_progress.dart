import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.xs,
      ),
      child: Row(
        children: List<Widget>.generate(
          totalSteps,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : AppSpacing.sm,
              ),
              child: Container(
                height: AppSizes.progressHeight,
                decoration: BoxDecoration(
                  color: index <= currentStep
                      ? context.colors.moss
                      : context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadii.grain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
