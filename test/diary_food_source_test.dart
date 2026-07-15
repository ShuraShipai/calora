import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/diary_food_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists each food source and exposes its edit title', () {
    final titles = <DiaryFoodSource, String>{
      DiaryFoodSource.custom: 'Edit Custom Food',
      DiaryFoodSource.scanned: 'Edit Scanned Food',
      DiaryFoodSource.barcode: 'Edit Barcode Food',
    };

    for (final entry in titles.entries) {
      final food = DiaryEntry(
        id: 'food',
        meal: 'Breakfast',
        name: 'Food',
        serving: '1 serving',
        calories: 100,
        protein: 1,
        carbs: 2,
        fat: 3,
        loggedAt: DateTime(2026, 7, 15),
        source: entry.key,
      );

      expect(food.toMap()['source'], entry.key.storedValue);
      expect(food.source.editTitle, entry.value);
    }
  });

  test('accepts legacy scan source labels', () {
    expect(DiaryFoodSourceX.fromStored('Scan Food'), DiaryFoodSource.scanned);
    expect(
      DiaryFoodSourceX.fromStored('scan barcode'),
      DiaryFoodSource.barcode,
    );
  });
}
