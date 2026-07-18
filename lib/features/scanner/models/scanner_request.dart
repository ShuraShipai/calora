import 'package:calora/features/diary/models/meal_type.dart';

class ScannerRequest {
  const ScannerRequest({this.mealType = MealType.breakfast, this.barcodeValue});

  const ScannerRequest.barcode({MealType mealType = MealType.breakfast})
    : this(mealType: mealType);

  final MealType mealType;
  final String? barcodeValue;

  ScannerRequest withBarcode(String barcodeValue) =>
      ScannerRequest(mealType: mealType, barcodeValue: barcodeValue);
}
