import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class UnitsChoiceCards extends StatelessWidget {
  const UnitsChoiceCards({
    super.key,
    required this.metric,
    required this.onChanged,
  });
  final bool metric;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(child: _card(context, 'Metric', 'kg · cm · ml', true)),
      const SizedBox(width: AppSpacing.lg),
      Expanded(child: _card(context, 'Imperial', 'lb · ft/in · fl oz', false)),
    ],
  );

  Widget _card(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
  ) {
    final selected = metric == value;
    return Material(
      color: selected ? context.colors.mossTint : context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: BorderSide(
          color: selected ? context.colors.moss : context.colors.border,
          width: selected ? AppStrokes.selected : AppStrokes.thin,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: AppRadii.cardBorder,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
