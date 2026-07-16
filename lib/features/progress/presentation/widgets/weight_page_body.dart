import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:calora/features/progress/presentation/widgets/weight_history_list.dart';
import 'package:calora/features/progress/presentation/widgets/weight_summary_cards.dart';
import 'package:flutter/material.dart';

class WeightPageBody extends StatelessWidget {
  const WeightPageBody({
    super.key,
    required this.onLogWeight,
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.monthlyChangeKg,
    required this.entries,
  });

  final VoidCallback onLogWeight;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final double? monthlyChangeKg;
  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final sectionLabel = context.textTheme.labelSmall?.copyWith(
      color: context.colors.inkFaint,
      fontWeight: AppFontWeights.bold,
      letterSpacing: AppSpacing.xxs,
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WeightSummaryCards(
            currentWeightKg: currentWeightKg,
            targetWeightKg: targetWeightKg,
            monthlyChangeKg: monthlyChangeKg,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: CaloraActionButton(
            label: 'Log weight',
            onPressed: onLogWeight,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Text('History', style: sectionLabel),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WeightHistoryList(entries: entries),
        ),
      ],
    );
  }
}
