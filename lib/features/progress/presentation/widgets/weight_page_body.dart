import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/progress/presentation/widgets/weight_history_list.dart';
import 'package:calora/features/progress/presentation/widgets/weight_summary_cards.dart';
import 'package:calora/features/progress/presentation/widgets/weight_trend_card.dart';
import 'package:flutter/material.dart';

class WeightPageBody extends StatelessWidget {
  const WeightPageBody({super.key, required this.onLogWeight});

  final VoidCallback onLogWeight;

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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WeightSummaryCards(),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WeightTrendCard(),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WeightHistoryList(),
        ),
      ],
    );
  }
}
