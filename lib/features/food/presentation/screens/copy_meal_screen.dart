import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/food/presentation/widgets/copy_meal_empty_state.dart';
import 'package:calora/features/food/presentation/widgets/copy_meal_group.dart';
import 'package:calora/features/food/presentation/widgets/copy_meal_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CopyMealScreen extends StatefulWidget {
  const CopyMealScreen({super.key});

  @override
  State<CopyMealScreen> createState() => _CopyMealScreenState();
}

class _CopyMealScreenState extends State<CopyMealScreen> {
  bool _copying = false;

  MealType _targetMeal(BuildContext context) =>
      (ModalRoute.of(context)?.settings.arguments as MealSelectionArguments?)
          ?.mealType ??
      MealType.breakfast;

  Future<void> _copy(DiaryEntry entry) async {
    if (_copying) return;
    setState(() => _copying = true);
    try {
      await context.read<DiaryProvider>().add(
        DiaryEntry(
          id: '',
          meal: _targetMeal(context).storedValue,
          name: entry.name,
          serving: entry.serving,
          calories: entry.calories,
          protein: entry.protein,
          carbs: entry.carbs,
          fat: entry.fat,
          loggedAt: DateTime.now(),
          servingQuantity: entry.servingQuantity,
          servingUnit: entry.servingUnit,
          fiber: entry.fiber,
          sugar: entry.sugar,
          note: entry.note,
          source: entry.source,
        ),
      );
      if (!mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.diary,
        (route) => route.settings.name == AppRoutes.home,
      );
    } catch (_) {
      if (mounted) showCaloraMessage(context, 'Could not copy this meal.');
    } finally {
      if (mounted) setState(() => _copying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<DiaryProvider>().previousMealEntries;
    return CaloraPage(
      screenId: 'copymeal',
      title: 'Copy a previous meal',
      child: ListView(
        children: <Widget>[
          CaloraSection(child: const CopyMealIntro()),
          CaloraSection(
            child: entries.isEmpty
                ? const CopyMealEmptyState()
                : CopyMealGroup(
                    entries: entries,
                    copying: _copying,
                    onCopy: _copy,
                  ),
          ),
        ],
      ),
    );
  }
}
