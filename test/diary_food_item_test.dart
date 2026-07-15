import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/presentation/widgets/diary_data.dart';
import 'package:calora/features/diary/presentation/widgets/diary_food_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens saved food details in a bottom sheet', (tester) async {
    final entry = DiaryEntry(
      id: 'food-1',
      meal: 'Breakfast',
      name: 'Berry oats',
      serving: '1 bowl',
      servingQuantity: '1',
      servingUnit: 'bowl',
      calories: 320,
      protein: 12,
      carbs: 48,
      fat: 9,
      fiber: 7,
      sugar: 11,
      note: 'Made with almond milk',
      loggedAt: DateTime(2026, 7, 15),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: DiaryFoodItem(
            food: DiaryFoodData(
              name: entry.name,
              details: entry.serving,
              calories: '${entry.calories}',
              entry: entry,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Berry oats'));
    await tester.pumpAndSettle();

    expect(find.text('Food details'), findsOneWidget);
    expect(find.text('Serving quantity'), findsOneWidget);
    expect(find.text('Serving unit'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('bowl'), findsOneWidget);
    expect(find.text('320 kcal'), findsOneWidget);
    expect(find.text('Carbohydrates'), findsOneWidget);
    expect(find.text('7 g'), findsOneWidget);
    expect(find.text('Made with almond milk'), findsOneWidget);
  });

  testWidgets('shows edit and remove actions only when food can be managed', (
    tester,
  ) async {
    final entry = DiaryEntry(
      id: 'food-1',
      meal: 'Breakfast',
      name: 'Berry oats',
      serving: '1 bowl',
      calories: 320,
      protein: 12,
      carbs: 48,
      fat: 9,
      loggedAt: DateTime(2026, 7, 15),
    );
    final food = DiaryFoodData(
      name: entry.name,
      details: entry.serving,
      calories: '${entry.calories}',
      entry: entry,
    );

    await tester.pumpWidget(_foodItemApp(food));
    expect(find.byTooltip('Edit food'), findsNothing);
    expect(find.byTooltip('Remove food'), findsNothing);

    await tester.pumpWidget(_foodItemApp(food, canManage: true));
    expect(find.byTooltip('Edit food'), findsOneWidget);
    expect(find.byTooltip('Remove food'), findsOneWidget);
  });
}

Widget _foodItemApp(DiaryFoodData food, {bool canManage = false}) =>
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: DiaryFoodItem(food: food, canManage: canManage),
      ),
    );
