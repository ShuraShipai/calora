import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      child: Row(
        children: <Widget>[
          const Spacer(),
          TextButton(onPressed: onSkip, child: const Text('Skip')),
        ],
      ),
    );
  }
}
