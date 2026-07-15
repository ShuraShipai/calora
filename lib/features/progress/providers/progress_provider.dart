import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:calora/features/progress/services/progress_service.dart';
import 'package:flutter/foundation.dart';

class ProgressProvider extends ChangeNotifier {
  ProgressProvider(this._service);

  final ProgressService _service;
  StreamSubscription<List<WaterEntry>>? _waterSubscription;
  StreamSubscription<List<WeightEntry>>? _weightSubscription;
  String? _uid;
  List<WaterEntry> _waterEntries = const <WaterEntry>[];
  List<WeightEntry> _weightEntries = const <WeightEntry>[];

  List<WaterEntry> get waterEntries => _waterEntries;
  List<WeightEntry> get weightEntries => _weightEntries;

  List<WaterEntry> get waterEntriesToday =>
      _waterEntries.where((entry) => _isToday(entry.loggedAt)).toList();
  int get waterTodayMl =>
      waterEntriesToday.fold(0, (total, entry) => total + entry.amountMl);
  WeightEntry? get latestWeight =>
      _weightEntries.isEmpty ? null : _weightEntries.first;

  double? get weightChangeThisMonth {
    final now = DateTime.now();
    final monthEntries = _weightEntries
        .where(
          (entry) =>
              entry.loggedAt.year == now.year &&
              entry.loggedAt.month == now.month,
        )
        .toList();
    if (monthEntries.length < 2) return null;
    return monthEntries.first.weightKg - monthEntries.last.weightKg;
  }

  List<double> get weightTrend => _weightEntries
      .take(7)
      .toList()
      .reversed
      .map((entry) => entry.weightKg)
      .toList();

  void updateUser(UserProfile? profile) {
    if (_uid == profile?.uid) return;
    _uid = profile?.uid;
    unawaited(_waterSubscription?.cancel());
    unawaited(_weightSubscription?.cancel());
    _waterEntries = const <WaterEntry>[];
    _weightEntries = const <WeightEntry>[];
    notifyListeners();
    final uid = _uid;
    if (uid == null) return;
    _waterSubscription = _service.watchWaterEntries(uid).listen((entries) {
      _waterEntries = entries;
      notifyListeners();
    });
    _weightSubscription = _service.watchWeightEntries(uid).listen((entries) {
      _weightEntries = entries;
      notifyListeners();
    });
  }

  Future<void> addWater(int amountMl) async {
    if (amountMl <= 0) throw ArgumentError.value(amountMl, 'amountMl');
    final uid = _requireUser();
    await _service.addWaterEntry(
      uid,
      WaterEntry(id: '', amountMl: amountMl, loggedAt: DateTime.now()),
    );
  }

  Future<void> addWeight({
    required double weightKg,
    required DateTime loggedAt,
    String? note,
  }) async {
    if (weightKg <= 0) throw ArgumentError.value(weightKg, 'weightKg');
    final uid = _requireUser();
    await _service.addWeightEntry(
      uid,
      WeightEntry(id: '', weightKg: weightKg, loggedAt: loggedAt, note: note),
    );
  }

  String _requireUser() {
    final uid = _uid;
    if (uid == null) throw StateError('Sign in to save progress.');
    return uid;
  }

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

  @override
  void dispose() {
    unawaited(_waterSubscription?.cancel());
    unawaited(_weightSubscription?.cancel());
    super.dispose();
  }
}
