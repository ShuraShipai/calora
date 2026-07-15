enum MealImageSource { camera, gallery }

/// A locally captured image made available to the meal-label suggestion flow.
///
/// The capture implementation owns how the path is created (camera or gallery);
/// recognition only needs a readable local file path.
class MealImage {
  const MealImage({
    required this.path,
    required this.source,
    required this.capturedAt,
  });

  final String path;
  final MealImageSource source;
  final DateTime capturedAt;
}

class MealImageCaptureResult {
  const MealImageCaptureResult.image(this.image)
    : message = null,
      isCancelled = false;

  const MealImageCaptureResult.unavailable(this.message)
    : image = null,
      isCancelled = false;

  const MealImageCaptureResult.cancelled()
    : image = null,
      message = null,
      isCancelled = true;

  final MealImage? image;
  final String? message;
  final bool isCancelled;
}
