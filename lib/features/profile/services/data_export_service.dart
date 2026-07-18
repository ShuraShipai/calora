import 'dart:convert';

import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class DataExportService {
  Future<void> export({
    required List<DiaryEntry> diaryEntries,
    required List<WaterEntry> waterEntries,
    required List<WeightEntry> weightEntries,
  });
}

class ShareDataExportService implements DataExportService {
  @override
  Future<void> export({
    required List<DiaryEntry> diaryEntries,
    required List<WaterEntry> waterEntries,
    required List<WeightEntry> weightEntries,
  }) {
    final csv = _csv(diaryEntries, waterEntries, weightEntries);
    return SharePlus.instance.share(
      ShareParams(
        title: 'Calora data export',
        subject: 'Calora data export',
        text: 'Your Calora data export is attached as a CSV file.',
        files: <XFile>[XFile.fromData(utf8.encode(csv), mimeType: 'text/csv')],
        fileNameOverrides: <String>['calora-data-export.csv'],
      ),
    );
  }

  String _csv(
    List<DiaryEntry> diaryEntries,
    List<WaterEntry> waterEntries,
    List<WeightEntry> weightEntries,
  ) => <String>[
    'type,date,meal,name,serving,calories,protein_g,carbs_g,fat_g,amount_ml,weight_kg,note',
    ...diaryEntries.map(
      (entry) => _row(<Object?>[
        'diary',
        entry.loggedAt.toIso8601String(),
        entry.meal,
        entry.name,
        entry.serving,
        entry.calories,
        entry.protein,
        entry.carbs,
        entry.fat,
        '',
        '',
        entry.note,
      ]),
    ),
    ...waterEntries.map(
      (entry) => _row(<Object?>[
        'water',
        entry.loggedAt.toIso8601String(),
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        entry.amountMl,
        '',
        '',
      ]),
    ),
    ...weightEntries.map(
      (entry) => _row(<Object?>[
        'weight',
        entry.loggedAt.toIso8601String(),
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        entry.weightKg,
        entry.note,
      ]),
    ),
  ].join('\n');

  String _row(List<Object?> values) => values
      .map((value) => '"${(value ?? '').toString().replaceAll('"', '""')}"')
      .join(',');
}
