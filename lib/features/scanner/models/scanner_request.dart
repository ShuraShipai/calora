import 'package:calora/features/diary/models/meal_type.dart';

enum ScannerMode { meal, barcode }

class ScannerRequest {
  const ScannerRequest({
    required this.mode,
    this.mealType = MealType.breakfast,
    this.barcodeValue,
  });

  const ScannerRequest.meal({MealType mealType = MealType.breakfast})
    : this(mode: ScannerMode.meal, mealType: mealType);

  const ScannerRequest.barcode({MealType mealType = MealType.breakfast})
    : this(mode: ScannerMode.barcode, mealType: mealType);

  final ScannerMode mode;
  final MealType mealType;
  final String? barcodeValue;

  ScannerRequest withBarcode(String barcodeValue) => ScannerRequest(
    mode: mode,
    mealType: mealType,
    barcodeValue: barcodeValue,
  );
}
