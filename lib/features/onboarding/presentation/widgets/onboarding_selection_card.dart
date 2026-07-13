import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class OnboardingSelectionCard extends StatelessWidget {
  const OnboardingSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.icon,
    this.centered = false,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.mossTint : colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: BorderSide(
          color: selected ? colors.moss : colors.border,
          width: AppStrokes.selected,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.section,
            vertical: AppSpacing.xxl,
          ),
          child: centered
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _text(context, TextAlign.center),
                )
              : Row(
                  children: <Widget>[
                    if (icon != null) ...<Widget>[
                      Container(
                        width: AppSizes.onboardingIcon,
                        height: AppSizes.onboardingIcon,
                        decoration: BoxDecoration(
                          color: selected ? colors.moss : colors.surfaceAlt,
                          borderRadius: AppRadii.inputBorder,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          size: AppSizes.icon,
                          color: selected ? colors.onAccent : colors.moss,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _text(context, TextAlign.start),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _text(BuildContext context, TextAlign align) => <Widget>[
    Text(
      title,
      textAlign: align,
      style: context.textTheme.titleMedium?.copyWith(
        fontSize: AppFontSizes.control,
      ),
    ),
    const SizedBox(height: AppSpacing.xxs),
    Text(
      subtitle,
      textAlign: align,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.colors.inkSoft,
      ),
    ),
  ];
}
