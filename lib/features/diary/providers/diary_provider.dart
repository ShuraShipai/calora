import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:flutter/foundation.dart';

class DiaryProvider extends ChangeNotifier {
  DiaryProvider(this._service);
  final DiaryService _service;
  StreamSubscription<List<DiaryEntry>>? _subscription;
  List<DiaryEntry> _entries = const <DiaryEntry>[];
  String? _uid;
  List<DiaryEntry> get entries => _entries;
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
  int get caloriesToday => _entries
      .where((entry) => _isToday(entry.loggedAt))
      .fold(0, (sum, entry) => sum + entry.calories);
  int get proteinToday => _entries
      .where((entry) => _isToday(entry.loggedAt))
      .fold(0, (sum, entry) => sum + entry.protein);
  int get carbsToday => _entries
      .where((entry) => _isToday(entry.loggedAt))
      .fold(0, (sum, entry) => sum + entry.carbs);
  int get fatToday => _entries
      .where((entry) => _isToday(entry.loggedAt))
      .fold(0, (sum, entry) => sum + entry.fat);

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

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
    await _service.addEntry(uid, entry);
  }

  Future<void> remove(String id) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.deleteEntry(uid, id);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
