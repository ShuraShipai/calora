import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:calora/features/scanner/providers/meal_capture_provider.dart';
import 'package:calora/features/scanner/services/meal_image_capture_service.dart';
import 'package:calora/features/scanner/services/meal_label_suggestion_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final image = MealImage(
    path: '/tmp/meal.jpg',
    source: MealImageSource.camera,
    capturedAt: DateTime(2026),
  );

  test(
    'uses only labels returned by the injected local suggestion service',
    () async {
      final provider = MealCaptureProvider(
        _ImageCaptureService(MealImageCaptureResult.image(image)),
        _SuggestionService(
          const MealLabelSuggestionResult.available(<MealLabelSuggestion>[
            MealLabelSuggestion(label: 'salad', confidence: 0.82),
          ]),
        ),
      );

      await provider.capture(MealImageSource.camera);

      expect(provider.image, image);
      expect(provider.result?.labels.single.label, 'salad');
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    },
  );

  test(
    'reports unavailable recognition without fabricating a food label',
    () async {
      final provider = MealCaptureProvider(
        _ImageCaptureService(MealImageCaptureResult.image(image)),
        _SuggestionService(
          const MealLabelSuggestionResult.unavailable('No confident labels.'),
        ),
      );

      await provider.capture(MealImageSource.gallery);

      expect(provider.result?.isAvailable, isFalse);
      expect(provider.result?.labels, isEmpty);
      expect(provider.result?.unavailableMessage, 'No confident labels.');
    },
  );

  test('surfaces unavailable image capture without a suggested food', () async {
    final provider = MealCaptureProvider(
      const UnavailableMealImageCaptureService(),
      _SuggestionService(
        const MealLabelSuggestionResult.unavailable('Not called.'),
      ),
    );

    await provider.capture(MealImageSource.camera);

    expect(provider.image, isNull);
    expect(provider.result, isNull);
    expect(provider.errorMessage, isNotNull);
  });
}

class _ImageCaptureService implements MealImageCaptureService {
  const _ImageCaptureService(this.result);

  final MealImageCaptureResult result;

  @override
  Future<MealImageCaptureResult> capture(MealImageSource source) async =>
      result;
}

class _SuggestionService implements MealLabelSuggestionService {
  const _SuggestionService(this.result);

  final MealLabelSuggestionResult result;

  @override
  Future<MealLabelSuggestionResult> suggestLabels(MealImage image) async =>
      result;
}
