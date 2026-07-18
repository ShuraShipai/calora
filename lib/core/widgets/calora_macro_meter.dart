import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraMacroMeter extends StatelessWidget {
  const CaloraMacroMeter({
    super.key,
    required this.label,
    required this.value,
    required this.filled,
    required this.color,
  });

  final String label;
  final String value;
  final int filled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: context.textTheme.labelMedium),
            Text(
              value,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List<Widget>.generate(
            8,
            (index) => Expanded(
              child: Container(
                height: AppSpacing.xxl,
                margin: EdgeInsets.only(right: index == 7 ? 0 : AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: index < filled ? color : context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadii.grain),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
