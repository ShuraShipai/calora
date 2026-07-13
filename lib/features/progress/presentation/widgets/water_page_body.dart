import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/progress/presentation/widgets/water_history_list.dart';
import 'package:calora/features/progress/presentation/widgets/water_quick_add_buttons.dart';
import 'package:calora/features/progress/presentation/widgets/water_ring_card.dart';
import 'package:flutter/material.dart';

class WaterPageBody extends StatelessWidget {
  const WaterPageBody({
    super.key,
    required this.amountLabel,
    required this.entries,
    required this.onAdd250,
    required this.onAdd500,
    required this.onCustom,
  });

  final String amountLabel;
  final List<WaterHistoryEntry> entries;
  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WaterRingCard(amountLabel: amountLabel),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Text(
            'Quick add',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkFaint,
              fontWeight: AppFontWeights.bold,
              letterSpacing: AppSpacing.xxs,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WaterQuickAddButtons(
            onAdd250: onAdd250,
            onAdd500: onAdd500,
            onCustom: onCustom,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Text(
            'Today',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkFaint,
              fontWeight: AppFontWeights.bold,
              letterSpacing: AppSpacing.xxs,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: WaterHistoryList(entries: entries),
        ),
      ],
    );
  }
}
