import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_brand_mark.dart';
import 'package:flutter/material.dart';

class SplashBrandContent extends StatelessWidget {
  const SplashBrandContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CaloraBrandMark(),
        const SizedBox(height: AppSpacing.section),
        Text('Calora', style: context.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.section),
        Text(
          'Eat well. Feel steady.',
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: AppFontSizes.bodySmall,
            color: context.colors.inkSoft,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        SizedBox(
          width: AppSizes.splashProgressWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.grain),
            child: const LinearProgressIndicator(
              minHeight: AppStrokes.spinner,
              value: AppOpacity.splashProgress,
            ),
          ),
        ),
      ],
    );
  }
}
