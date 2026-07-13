import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:flutter/material.dart';

class ScanNutritionSummary extends StatelessWidget {
  const ScanNutritionSummary({super.key, required this.items});

  final List<ScanItem> items;

  @override
  Widget build(BuildContext context) {
    final kcal = items.fold<int>(0, (value, item) => value + item.kcal);
    final protein = items.fold<int>(0, (value, item) => value + item.protein);
    final carbs = items.fold<int>(0, (value, item) => value + item.carbs);
    final fat = items.fold<int>(0, (value, item) => value + item.fat);

    return Row(
      children: <Widget>[
        Expanded(
          child: CaloraStatPill(value: '$kcal', label: 'Kcal'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CaloraStatPill(value: '${protein}g', label: 'Protein'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CaloraStatPill(value: '${carbs}g', label: 'Carbs'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CaloraStatPill(value: '${fat}g', label: 'Fat'),
        ),
      ],
    );
  }
}
