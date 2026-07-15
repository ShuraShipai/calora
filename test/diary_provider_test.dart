import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiaryProvider nutrition', () {
    late _FakeDiaryService service;
    late DiaryProvider provider;

    setUp(() {
      service = _FakeDiaryService();
      provider = DiaryProvider(service);
      provider.updateUser(
        const UserProfile(
          uid: 'user-1',
          name: 'User',
          email: 'a@b.com',
          isAnonymous: false,
          onboardingComplete: true,
        ),
      );
    });

    tearDown(() {
      provider.dispose();
      service.dispose();
    });

    test('derives the current day nutrition from saved entries', () async {
      final now = DateTime.now();
      service.emit(<DiaryEntry>[
        _entry(
          id: 'one',
          loggedAt: now,
          calories: 400,
          protein: 25,
          carbs: 50,
          fat: 12,
          fiber: 8,
          sugar: 6,
        ),
        _entry(
          id: 'two',
          loggedAt: now,
          calories: 200,
          protein: 10,
          carbs: 20,
          fat: 5,
          fiber: 4,
          sugar: 3,
        ),
        _entry(
          id: 'old',
          loggedAt: now.subtract(const Duration(days: 1)),
          calories: 999,
          protein: 99,
          carbs: 99,
          fat: 99,
          fiber: 99,
          sugar: 99,
        ),
      ]);
      await _flush();

      expect(provider.nutritionToday.calories, 600);
      expect(provider.nutritionToday.protein, 35);
      expect(provider.nutritionToday.carbs, 70);
      expect(provider.nutritionToday.fat, 17);
      expect(provider.nutritionToday.fiber, 12);
      expect(provider.nutritionToday.sugar, 9);
    });

    test('updates saved entries through the service', () async {
      final original = _entry(
        id: 'entry-1',
        loggedAt: DateTime.now(),
        calories: 100,
        protein: 10,
        carbs: 20,
        fat: 5,
      );
      service.emit(<DiaryEntry>[original]);
      await _flush();

      await provider.update(
        original.copyWith(calories: 250, protein: 25, carbs: 30, fat: 12),
      );

      expect(service.updatedEntry?.id, 'entry-1');
      expect(provider.nutritionToday.calories, 250);
      expect(provider.nutritionToday.protein, 25);
      expect(provider.nutritionToday.carbs, 30);
      expect(provider.nutritionToday.fat, 12);
    });

    test(
      'updates nutrition immediately when entries are added and removed',
      () async {
        final entry = _entry(
          id: '',
          loggedAt: DateTime.now(),
          calories: 300,
          protein: 30,
          carbs: 40,
          fat: 10,
        );

        await provider.add(entry);

        expect(provider.nutritionToday.calories, 300);
        expect(provider.nutritionToday.protein, 30);
        expect(provider.nutritionToday.carbs, 40);
        expect(provider.nutritionToday.fat, 10);

        final savedId = provider.entries.single.id;
        expect(savedId, isNotEmpty);
        await provider.remove(savedId);

        expect(provider.nutritionToday.calories, 0);
        expect(provider.nutritionToday.protein, 0);
        expect(provider.nutritionToday.carbs, 0);
        expect(provider.nutritionToday.fat, 0);
        expect(service.deletedEntryId, savedId);
      },
    );
  });
}

DiaryEntry _entry({
  required String id,
  required DateTime loggedAt,
  int calories = 0,
  int protein = 0,
  int carbs = 0,
  int fat = 0,
  int? fiber,
  int? sugar,
}) => DiaryEntry(
  id: id,
  meal: 'Breakfast',
  name: 'Food',
  serving: '1 serving',
  calories: calories,
  protein: protein,
  carbs: carbs,
  fat: fat,
  loggedAt: loggedAt,
  fiber: fiber,
  sugar: sugar,
);

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _FakeDiaryService implements DiaryService {
  final _entries = StreamController<List<DiaryEntry>>.broadcast();
  DiaryEntry? updatedEntry;
  DiaryEntry? addedEntry;
  String? deletedEntryId;

  void emit(List<DiaryEntry> value) => _entries.add(value);

  @override
  Future<void> addEntry(String uid, DiaryEntry entry) async {
    addedEntry = entry;
  }

  @override
  Future<void> deleteEntry(String uid, String entryId) async {
    deletedEntryId = entryId;
  }

  @override
  Future<void> updateEntry(String uid, DiaryEntry entry) async {
    updatedEntry = entry;
  }

  @override
  Stream<List<DiaryEntry>> watchEntries(String uid) => _entries.stream;

  void dispose() => _entries.close();
}
