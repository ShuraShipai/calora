import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_detail_row.dart';
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
          DiaryFoodDetailRow(label: 'Name', value: entry.name),
          DiaryFoodDetailRow(
            label: 'Serving quantity',
            value: _valueOrDash(entry.displayServingQuantity),
          ),
          DiaryFoodDetailRow(
            label: 'Serving unit',
            value: _valueOrDash(entry.displayServingUnit),
          ),
          DiaryFoodDetailRow(
            label: 'Calories',
            value: '${entry.calories} kcal',
          ),
          if (entry.hasNote)
            DiaryFoodDetailRow(label: 'Note', value: entry.note!.trim()),
          DiaryFoodDetailRow(label: 'Protein', value: '${entry.protein} g'),
          DiaryFoodDetailRow(label: 'Carbohydrates', value: '${entry.carbs} g'),
          DiaryFoodDetailRow(label: 'Fat', value: '${entry.fat} g'),
          DiaryFoodDetailRow(label: 'Fiber', value: _gramsOrDash(entry.fiber)),
          DiaryFoodDetailRow(label: 'Sugar', value: _gramsOrDash(entry.sugar)),
        ],
      ),
    );
  }

  String _valueOrDash(String value) => value.isEmpty ? '—' : value;
  String _gramsOrDash(int? value) => value == null ? '—' : '$value g';
}
