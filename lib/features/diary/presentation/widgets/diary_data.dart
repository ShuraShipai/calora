import 'package:flutter/material.dart';

class DiaryFoodData {
  const DiaryFoodData({
    required this.name,
    required this.details,
    required this.calories,
  });

  final String name;
  final String details;
  final String calories;
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
  });

  final String label;
  final List<DiaryMealData> meals;
  final bool canAdd;
}
