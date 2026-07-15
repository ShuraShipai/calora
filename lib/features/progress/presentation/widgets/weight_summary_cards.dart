import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:flutter/material.dart';

class WeightSummaryCards extends StatelessWidget {
  const WeightSummaryCards({
    super.key,
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.monthlyChangeKg,
  });

  final double? currentWeightKg;
  final double? targetWeightKg;
  final double? monthlyChangeKg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _card(context, _weightLabel(currentWeightKg), 'Current'),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(child: _card(context, _weightLabel(targetWeightKg), 'Target')),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _card(
            context,
            _changeLabel(monthlyChangeKg),
            'This month',
            context.colors.moss,
          ),
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

  String _weightLabel(double? value) =>
      value == null ? '—' : '${value.toStringAsFixed(1)} kg';

  String _changeLabel(double? value) {
    if (value == null) return '—';
    return '${value >= 0 ? '+' : '−'}${value.abs().toStringAsFixed(1)} kg';
  }
}
