import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:flutter/material.dart';

class DiaryFoodDetailsSheet extends StatelessWidget {
  const DiaryFoodDetailsSheet({super.key, required this.entry});

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: 'Food details',
      child: Column(
        children: <Widget>[
          _DetailRow(label: 'Name', value: entry.name),
          _DetailRow(
            label: 'Serving quantity',
            value: _valueOrDash(entry.displayServingQuantity),
          ),
          _DetailRow(
            label: 'Serving unit',
            value: _valueOrDash(entry.displayServingUnit),
          ),
          _DetailRow(label: 'Calories', value: '${entry.calories} kcal'),
          if (entry.hasNote)
            _DetailRow(label: 'Note', value: entry.note!.trim()),
          _DetailRow(label: 'Protein', value: '${entry.protein} g'),
          _DetailRow(label: 'Carbohydrates', value: '${entry.carbs} g'),
          _DetailRow(label: 'Fat', value: '${entry.fat} g'),
          _DetailRow(label: 'Fiber', value: _gramsOrDash(entry.fiber)),
          _DetailRow(label: 'Sugar', value: _gramsOrDash(entry.sugar)),
        ],
      ),
    );
  }

  String _valueOrDash(String value) => value.isEmpty ? '—' : value;
  String _gramsOrDash(int? value) => value == null ? '—' : '$value g';
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
