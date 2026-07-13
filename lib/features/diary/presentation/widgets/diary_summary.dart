import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:flutter/material.dart';

class DiarySummary extends StatelessWidget {
  const DiarySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Diary',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: AppFontSizes.sectionTitle,
              ),
            ),
            Text(
              '13 July',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.inkSoft,
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        const CaloraCard(
          child: Row(
            children: <Widget>[
              Expanded(
                child: CaloraStatPill(value: '1,240', label: 'Kcal'),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: CaloraStatPill(value: '62g', label: 'Protein'),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: CaloraStatPill(value: '140g', label: 'Carbs'),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: CaloraStatPill(value: '38g', label: 'Fat'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
