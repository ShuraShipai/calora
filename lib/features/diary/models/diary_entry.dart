import 'package:calora/features/diary/models/diary_food_source.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.servingQuantity,
    this.servingUnit,
    this.fiber,
    this.sugar,
    this.note,
    this.source = DiaryFoodSource.custom,
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
      servingQuantity: data['servingQuantity'] as String?,
      servingUnit: data['servingUnit'] as String?,
      fiber: (data['fiber'] as num?)?.toInt(),
      sugar: (data['sugar'] as num?)?.toInt(),
      note: data['note'] as String?,
      source: DiaryFoodSourceX.fromStored(
        (data['source'] ?? data['foodSource'] ?? data['entrySource'])
            as String?,
      ),
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
  final String? servingQuantity;
  final String? servingUnit;
  final int? fiber;
  final int? sugar;
  final String? note;
  final DiaryFoodSource source;

  String get displayServingQuantity =>
      servingQuantity ?? _legacyServingParts.$1;
  String get displayServingUnit => servingUnit ?? _legacyServingParts.$2;
  bool get hasNote => note?.trim().isNotEmpty ?? false;

  (String, String) get _legacyServingParts {
    final parts = serving.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return ('', '');
    return (parts.first, parts.skip(1).join(' '));
  }

  DiaryEntry copyWith({
    String? id,
    String? meal,
    String? name,
    String? serving,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    DateTime? loggedAt,
    String? servingQuantity,
    String? servingUnit,
    int? fiber,
    int? sugar,
    String? note,
    DiaryFoodSource? source,
  }) => DiaryEntry(
    id: id ?? this.id,
    meal: meal ?? this.meal,
    name: name ?? this.name,
    serving: serving ?? this.serving,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    loggedAt: loggedAt ?? this.loggedAt,
    servingQuantity: servingQuantity ?? this.servingQuantity,
    servingUnit: servingUnit ?? this.servingUnit,
    fiber: fiber ?? this.fiber,
    sugar: sugar ?? this.sugar,
    note: note ?? this.note,
    source: source ?? this.source,
  );

  Map<String, Object?> toMap() => <String, Object?>{
    'meal': meal,
    'name': name,
    'serving': serving,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'loggedAt': Timestamp.fromDate(loggedAt),
    'servingQuantity': servingQuantity,
    'servingUnit': servingUnit,
    'fiber': fiber,
    'sugar': sugar,
    'note': hasNote ? note!.trim() : null,
    'source': source.storedValue,
  };
}
