import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:image_picker/image_picker.dart';

/// Isolates camera and gallery SDKs from meal-scan UI and state.
///
/// A platform implementation can return a readable local image path without
/// changing recognition or presentation code.
abstract interface class MealImageCaptureService {
  Future<MealImageCaptureResult> capture(MealImageSource source);
}

/// Safe default while no picker/camera implementation is registered.
class UnavailableMealImageCaptureService implements MealImageCaptureService {
  const UnavailableMealImageCaptureService();

  @override
  Future<MealImageCaptureResult> capture(MealImageSource source) async =>
      const MealImageCaptureResult.unavailable(
        'Photo capture is not available on this device.',
      );
}

abstract interface class MealImagePicker {
  Future<String?> pickImagePath(MealImageSource source);
}

/// Captures a meal image locally. The image path is passed only to on-device
/// labeling; no photo is uploaded by this service.
class ImagePickerMealImageCaptureService implements MealImageCaptureService {
  ImagePickerMealImageCaptureService({
    MealImagePicker? picker,
    DateTime Function()? clock,
  }) : _picker = picker ?? _ImagePickerAdapter(ImagePicker()),
       _clock = clock ?? DateTime.now;

  final MealImagePicker _picker;
  final DateTime Function() _clock;

  @override
  Future<MealImageCaptureResult> capture(MealImageSource source) async {
    try {
      final path = await _picker.pickImagePath(source);
      if (path == null || path.trim().isEmpty) {
        return const MealImageCaptureResult.cancelled();
      }
      return MealImageCaptureResult.image(
        MealImage(path: path, source: source, capturedAt: _clock()),
      );
    } on Object catch (_) {
      return const MealImageCaptureResult.unavailable(
        'Could not access the selected photo.',
      );
    }
  }
}

class _ImagePickerAdapter implements MealImagePicker {
  const _ImagePickerAdapter(this._picker);

  final ImagePicker _picker;

  @override
  Future<String?> pickImagePath(MealImageSource source) async =>
      (await _picker.pickImage(
        source: source == MealImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
      ))?.path;
}
