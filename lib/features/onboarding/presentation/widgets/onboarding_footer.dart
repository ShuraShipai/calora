import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:flutter/material.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.showBack,
    required this.isLastStep,
    required this.onBack,
    required this.onNext,
  });

  final bool showBack;
  final bool isLastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.xxl,
        AppSpacing.page,
        AppSpacing.loose,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Visibility(
              visible: showBack,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: CaloraActionButton(
                label: 'Back',
                style: CaloraActionButtonStyle.secondary,
                onPressed: onBack,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: CaloraActionButton(
              label: isLastStep ? 'Get started' : 'Next',
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
