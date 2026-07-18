import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/profile/services/data_export_service.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:flutter/foundation.dart';

class DataExportProvider extends ChangeNotifier {
  DataExportProvider(this._service);
  final DataExportService _service;
  bool _isExporting = false;
  String? _errorMessage;
  bool get isExporting => _isExporting;
  String? get errorMessage => _errorMessage;

  Future<bool> export({
    required List<DiaryEntry> diaryEntries,
    required List<WaterEntry> waterEntries,
    required List<WeightEntry> weightEntries,
  }) async {
    if (_isExporting) return false;
    _isExporting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.export(
        diaryEntries: diaryEntries,
        waterEntries: waterEntries,
        weightEntries: weightEntries,
      );
      return true;
    } catch (_) {
      _errorMessage = 'Could not export your data.';
      return false;
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}
