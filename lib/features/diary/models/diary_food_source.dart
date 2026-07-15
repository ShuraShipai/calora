enum DiaryFoodSource { custom, scanned, barcode }

extension DiaryFoodSourceX on DiaryFoodSource {
  String get storedValue => switch (this) {
    DiaryFoodSource.custom => 'custom',
    DiaryFoodSource.scanned => 'scanned',
    DiaryFoodSource.barcode => 'barcode',
  };

  String get editTitle => switch (this) {
    DiaryFoodSource.custom => 'Edit Custom Food',
    DiaryFoodSource.scanned => 'Edit Scanned Food',
    DiaryFoodSource.barcode => 'Edit Barcode Food',
  };

  static DiaryFoodSource fromStored(String? value) => switch (value
      ?.trim()
      .toLowerCase()) {
    'scan' || 'scanned' || 'scan food' || 'scanner' => DiaryFoodSource.scanned,
    'barcode' || 'scan barcode' || 'barcode food' => DiaryFoodSource.barcode,
    _ => DiaryFoodSource.custom,
  };
}
