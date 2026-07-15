class ScanItem {
  const ScanItem({
    required this.name,
    required this.amount,
    required this.unit,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.confidence,
    this.fiber,
    this.sugar,
  });

  final String name;
  final String amount;
  final String unit;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
  final int? fiber;
  final int? sugar;
  final String confidence;

  String get details => '$amount $unit · ~$kcal kcal';
}

class ScanItemEditResult {
  const ScanItemEditResult.saved(this.item) : removed = false;

  const ScanItemEditResult.removed() : item = null, removed = true;

  final ScanItem? item;
  final bool removed;
}
