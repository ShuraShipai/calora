import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calora/features/diary/models/meal_type.dart';

class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.meal,
    required this.name,
    required this.serving,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.loggedAt,
  });

  factory DiaryEntry.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DiaryEntry(
      id: doc.id,
      meal: data['meal'] as String? ?? 'Snack',
      name: data['name'] as String? ?? '',
      serving: data['serving'] as String? ?? '',
      calories: (data['calories'] as num?)?.toInt() ?? 0,
      protein: (data['protein'] as num?)?.toInt() ?? 0,
      carbs: (data['carbs'] as num?)?.toInt() ?? 0,
      fat: (data['fat'] as num?)?.toInt() ?? 0,
      loggedAt: (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String id;
  final String meal;
  MealType get mealType => MealTypeX.fromStored(meal);
  final String name;
  final String serving;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime loggedAt;

  Map<String, Object> toMap() => <String, Object>{
    'meal': meal,
    'name': name,
    'serving': serving,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'loggedAt': Timestamp.fromDate(loggedAt),
  };
}
