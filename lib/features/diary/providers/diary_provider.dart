import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/diary_nutrition_totals.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:flutter/foundation.dart';

class DiaryProvider extends ChangeNotifier {
  DiaryProvider(this._service);
  final DiaryService _service;
  StreamSubscription<List<DiaryEntry>>? _subscription;
  List<DiaryEntry> _entries = const <DiaryEntry>[];
  String? _uid;
  List<DiaryEntry> get entries => _entries;

  /// Saved diary entries available to the Copy previous meal flow.
  ///
  /// This intentionally includes today's entries so a newly saved food can be
  /// re-logged immediately for another meal.
  List<DiaryEntry> get previousMealEntries => _entries;

  /// Returns totals from entries logged on [date], regardless of meal type.
  DiaryNutritionTotals nutritionFor(DateTime date) => _entries
      .where((entry) => _isSameDay(entry.loggedAt, date))
      .fold(
        const DiaryNutritionTotals.zero(),
        (totals, entry) => totals.add(DiaryNutritionTotals.fromEntry(entry)),
      );

  /// Returns totals for [startInclusive, endExclusive).
  DiaryNutritionTotals nutritionBetween(
    DateTime startInclusive,
    DateTime endExclusive,
  ) => _entries
      .where(
        (entry) =>
            !entry.loggedAt.isBefore(startInclusive) &&
            entry.loggedAt.isBefore(endExclusive),
      )
      .fold(
        const DiaryNutritionTotals.zero(),
        (totals, entry) => totals.add(DiaryNutritionTotals.fromEntry(entry)),
      );
  List<DiaryEntry> entriesFor(DateTime date, MealType type) => _entries
      .where(
        (entry) =>
            entry.loggedAt.year == date.year &&
            entry.loggedAt.month == date.month &&
            entry.loggedAt.day == date.day &&
            entry.mealType == type,
      )
      .toList();
  int caloriesFor(DateTime date, MealType type) =>
      entriesFor(date, type).fold(0, (sum, entry) => sum + entry.calories);
  DiaryNutritionTotals get nutritionToday => nutritionFor(DateTime.now());
  int get caloriesToday => nutritionToday.calories;
  int get proteinToday => nutritionToday.protein;
  int get carbsToday => nutritionToday.carbs;
  int get fatToday => nutritionToday.fat;
  int get fiberToday => nutritionToday.fiber;
  int get sugarToday => nutritionToday.sugar;

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  void updateUser(UserProfile? profile) {
    if (_uid == profile?.uid) return;
    _uid = profile?.uid;
    unawaited(_subscription?.cancel());
    _entries = const <DiaryEntry>[];
    notifyListeners();
    if (_uid == null) return;
    _subscription = _service.watchEntries(_uid!).listen((entries) {
      _entries = entries;
      notifyListeners();
    });
  }

  Future<void> add(DiaryEntry entry) async {
    final uid = _uid;
    if (uid == null) throw StateError('Sign in to save diary entries.');
    final savedEntry = entry.id.isEmpty
        ? entry.copyWith(id: _newEntryId())
        : entry;
    final previousEntries = _entries;
    _entries = <DiaryEntry>[savedEntry, ..._entries];
    notifyListeners();
    try {
      await _service.addEntry(uid, savedEntry);
    } on Object {
      _entries = previousEntries;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(DiaryEntry entry) async {
    final uid = _uid;
    if (uid == null) throw StateError('Sign in to update diary entries.');
    if (entry.id.isEmpty) throw ArgumentError.value(entry.id, 'entry.id');
    final previousEntries = _entries;
    _entries = _entries
        .map((existing) => existing.id == entry.id ? entry : existing)
        .toList(growable: false);
    notifyListeners();
    try {
      await _service.updateEntry(uid, entry);
    } on Object {
      _entries = previousEntries;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    final uid = _uid;
    if (uid == null) return;
    final previousEntries = _entries;
    _entries = _entries
        .where((entry) => entry.id != id)
        .toList(growable: false);
    notifyListeners();
    try {
      await _service.deleteEntry(uid, id);
    } on Object {
      _entries = previousEntries;
      notifyListeners();
      rethrow;
    }
  }

  String _newEntryId() =>
      'local-${DateTime.now().microsecondsSinceEpoch}-${_entries.length}';

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
