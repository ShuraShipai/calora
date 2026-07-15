import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/services/meal_image_capture_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a camera image path into a local meal image', () async {
    final service = ImagePickerMealImageCaptureService(
      picker: _Picker('/tmp/meal.jpg'),
      clock: () => DateTime(2026, 7, 15),
    );

    final result = await service.capture(MealImageSource.camera);

    expect(result.image?.path, '/tmp/meal.jpg');
    expect(result.image?.source, MealImageSource.camera);
    expect(result.image?.capturedAt, DateTime(2026, 7, 15));
    expect(result.isCancelled, isFalse);
  });

  test('treats a cancelled gallery picker without creating an image', () async {
    final service = ImagePickerMealImageCaptureService(picker: _Picker(null));

    final result = await service.capture(MealImageSource.gallery);

    expect(result.image, isNull);
    expect(result.isCancelled, isTrue);
  });

  test('does not turn picker failures into a food suggestion', () async {
    final service = ImagePickerMealImageCaptureService(
      picker: _ThrowingPicker(),
    );

    final result = await service.capture(MealImageSource.camera);

    expect(result.image, isNull);
    expect(result.message, 'Could not access the selected photo.');
  });
}

class _Picker implements MealImagePicker {
  const _Picker(this.path);

  final String? path;

  @override
  Future<String?> pickImagePath(MealImageSource source) async => path;
}

class _ThrowingPicker implements MealImagePicker {
  @override
  Future<String?> pickImagePath(MealImageSource source) async =>
      throw StateError('Picker failure');
}
