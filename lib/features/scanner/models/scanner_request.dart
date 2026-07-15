import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';

enum ScannerMode { meal, barcode }

class ScannerRequest {
  const ScannerRequest({
    required this.mode,
    this.mealType = MealType.breakfast,
    this.barcodeValue,
    this.mealImage,
    this.mealLabelSuggestions = const <MealLabelSuggestion>[],
  });

  const ScannerRequest.meal({MealType mealType = MealType.breakfast})
    : this(mode: ScannerMode.meal, mealType: mealType);

  const ScannerRequest.barcode({MealType mealType = MealType.breakfast})
    : this(mode: ScannerMode.barcode, mealType: mealType);

  final ScannerMode mode;
  final MealType mealType;
  final String? barcodeValue;
  final MealImage? mealImage;
  final List<MealLabelSuggestion> mealLabelSuggestions;

  ScannerRequest withBarcode(String barcodeValue) => ScannerRequest(
    mode: mode,
    mealType: mealType,
    barcodeValue: barcodeValue,
  );

  ScannerRequest withMealScan({
    required MealImage image,
    required List<MealLabelSuggestion> suggestions,
  }) => ScannerRequest(
    mode: mode,
    mealType: mealType,
    barcodeValue: barcodeValue,
    mealImage: image,
    mealLabelSuggestions: List<MealLabelSuggestion>.unmodifiable(suggestions),
  );
}
