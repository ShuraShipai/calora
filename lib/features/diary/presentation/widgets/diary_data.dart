import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:flutter/material.dart';

class DiaryFoodData {
  const DiaryFoodData({
    required this.name,
    required this.details,
    required this.calories,
    required this.entry,
  });

  final String name;
  final String details;
  final String calories;
  final DiaryEntry entry;
}

class DiaryMealData {
  const DiaryMealData({
    required this.name,
    required this.summary,
    required this.icon,
    this.foods = const <DiaryFoodData>[],
  });

  final String name;
  final String summary;
  final IconData icon;
  final List<DiaryFoodData> foods;
}

class DiaryDayData {
  const DiaryDayData({
    required this.label,
    required this.meals,
    this.canAdd = false,
    this.canManage = false,
  });

  final String label;
  final List<DiaryMealData> meals;
  final bool canAdd;
  final bool canManage;
}
