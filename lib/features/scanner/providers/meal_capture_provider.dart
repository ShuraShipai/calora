import 'package:calora/features/scanner/models/meal_image.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:calora/features/scanner/services/meal_image_capture_service.dart';
import 'package:calora/features/scanner/services/meal_label_suggestion_service.dart';
import 'package:flutter/foundation.dart';

/// Coordinates local image capture and ML Kit label suggestions for meal scan.
class MealCaptureProvider extends ChangeNotifier {
  MealCaptureProvider(this._captureService, this._suggestionService);

  final MealImageCaptureService _captureService;
  final MealLabelSuggestionService _suggestionService;

  bool _isLoading = false;
  MealImage? _image;
  MealLabelSuggestionResult? _result;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  MealImage? get image => _image;
  MealLabelSuggestionResult? get result => _result;
  String? get errorMessage => _errorMessage;

  Future<void> capture(MealImageSource source) async {
    if (_isLoading) return;
    _beginLoading();
    final capture = await _captureService.capture(source);
    if (capture.isCancelled) {
      _finishLoading();
      return;
    }
    final image = capture.image;
    if (image == null) {
      _errorMessage = capture.message ?? 'Could not capture a photo.';
      _finishLoading();
      return;
    }
    _image = image;
    await _suggest(image);
  }

  Future<void> analyse(MealImage image) async {
    if (_isLoading) return;
    _beginLoading();
    _image = image;
    await _suggest(image);
  }

  Future<void> _suggest(MealImage image) async {
    _result = await _suggestionService.suggestLabels(image);
    _finishLoading();
  }

  void clear() {
    if (_isLoading ||
        _image != null ||
        _result != null ||
        _errorMessage != null) {
      _isLoading = false;
      _image = null;
      _result = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _beginLoading() {
    _isLoading = true;
    _image = null;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    final suggestionService = _suggestionService;
    if (suggestionService is DisposableMealLabelSuggestionService) {
      suggestionService.dispose();
    }
    super.dispose();
  }
}
