import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:flutter/material.dart';

class WeightSummaryCards extends StatelessWidget {
  const WeightSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _card(context, '0 kg', 'Current')),
        const SizedBox(width: AppSpacing.lg),
        Expanded(child: _card(context, '0 kg', 'Target')),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _card(context, '0 kg', 'This month', context.colors.moss),
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    String value,
    String label, [
    Color? color,
  ]) {
    return CaloraCard(
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            style: context.textTheme.titleMedium?.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
