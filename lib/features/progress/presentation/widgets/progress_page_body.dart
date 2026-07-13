import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/progress/presentation/widgets/progress_filter_chips.dart';
import 'package:calora/features/progress/presentation/widgets/progress_insights_card.dart';
import 'package:calora/features/progress/presentation/widgets/progress_trends_card.dart';
import 'package:flutter/material.dart';

class ProgressPageBody extends StatelessWidget {
  const ProgressPageBody({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onWeightPressed,
  });

  final int selectedFilter;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback onWeightPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Text('Progress', style: context.textTheme.titleLarge),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressFilterChips(
            selectedIndex: selectedFilter,
            onSelected: onFilterSelected,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressInsightsCard(),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: ProgressTrendsCard(onWeightPressed: onWeightPressed),
        ),
      ],
    );
  }
}
