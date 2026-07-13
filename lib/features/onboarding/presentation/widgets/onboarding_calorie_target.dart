import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:flutter/material.dart';

class OnboardingCalorieTarget extends StatelessWidget {
  const OnboardingCalorieTarget({super.key});

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: <Widget>[
          Text('1,840', style: context.textTheme.displayLarge),
          Text(
            'calories / day',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
