import 'dart:async';

import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

abstract interface class MealLabelSuggestionService {
  Future<MealLabelSuggestionResult> suggestLabels(MealImage image);
}

abstract interface class DisposableMealLabelSuggestionService
    implements MealLabelSuggestionService {
  void dispose();
}

/// Runs ML Kit image labeling entirely on-device.
///
/// Labels are suggestions only; they are never converted into nutrition or
/// saved diary entries without the user's confirmation and portion input.
class MlKitMealLabelSuggestionService
    implements DisposableMealLabelSuggestionService {
  MlKitMealLabelSuggestionService({
    ImageLabeler? labeler,
    this.confidenceThreshold = defaultConfidenceThreshold,
  }) : assert(confidenceThreshold >= 0 && confidenceThreshold <= 1),
       _labeler =
           labeler ??
           ImageLabeler(
             options: ImageLabelerOptions(
               confidenceThreshold: confidenceThreshold,
             ),
           );

  static const defaultConfidenceThreshold = 0.60;

  final ImageLabeler _labeler;
  final double confidenceThreshold;

  @override
  Future<MealLabelSuggestionResult> suggestLabels(MealImage image) async {
    try {
      final labels = await _labeler.processImage(
        InputImage.fromFilePath(image.path),
      );
      final suggestions = labels
          .where(
            (label) =>
                label.label.trim().isNotEmpty &&
                label.confidence >= confidenceThreshold,
          )
          .map(
            (label) => MealLabelSuggestion(
              label: label.label.trim(),
              confidence: label.confidence,
            ),
          )
          .toList(growable: false);

      if (suggestions.isEmpty) {
        return const MealLabelSuggestionResult.unavailable(
          'No confident food labels were found. Add the food manually.',
        );
      }
      return MealLabelSuggestionResult.available(suggestions);
    } on Object catch (_) {
      return const MealLabelSuggestionResult.unavailable(
        'Could not analyse this photo. Add the food manually.',
      );
    }
  }

  @override
  void dispose() {
    unawaited(_labeler.close());
  }
}
