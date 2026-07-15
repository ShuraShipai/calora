class MealLabelSuggestion {
  const MealLabelSuggestion({required this.label, required this.confidence})
    : assert(label != ''),
      assert(confidence >= 0 && confidence <= 1);

  final String label;
  final double confidence;
}

class MealLabelSuggestionResult {
  const MealLabelSuggestionResult.available(this.labels)
    : unavailableMessage = null;

  const MealLabelSuggestionResult.unavailable(this.unavailableMessage)
    : labels = const <MealLabelSuggestion>[];

  final List<MealLabelSuggestion> labels;
  final String? unavailableMessage;

  bool get isAvailable => labels.isNotEmpty;
}
