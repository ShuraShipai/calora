import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:calora/features/scanner/providers/usda_nutrition_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsdaFoodConfirmationSheet extends StatefulWidget {
  const UsdaFoodConfirmationSheet({super.key, required this.suggestion});

  final MealLabelSuggestion suggestion;

  @override
  State<UsdaFoodConfirmationSheet> createState() =>
      _UsdaFoodConfirmationSheetState();
}

class _UsdaFoodConfirmationSheetState extends State<UsdaFoodConfirmationSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _foodName;
  final _grams = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foodName = TextEditingController(text: widget.suggestion.label);
  }

  @override
  void dispose() {
    _foodName.dispose();
    _grams.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CaloraSheet(
    title: 'Confirm food and amount',
    child: Consumer<UsdaNutritionLookupProvider>(
      builder: (context, lookup, _) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Nutrition is calculated from USDA FoodData Central after you confirm the food and grams.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            CaloraLabeledField(
              label: 'Food',
              controller: _foodName,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a food name'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xxl),
            CaloraLabeledField(
              label: 'Amount (g)',
              hint: 'e.g. 150',
              controller: _grams,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final grams = double.tryParse(value?.trim() ?? '');
                return grams == null || grams <= 0
                    ? 'Enter an amount greater than zero'
                    : null;
              },
            ),
            if (lookup.errorMessage case final message?) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            CaloraActionButton(
              label: lookup.isLoading ? 'Looking up nutrition…' : 'Add food',
              onPressed: lookup.isLoading ? null : _lookupNutrition,
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _lookupNutrition() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final grams = double.parse(_grams.text.trim());
    final nutrition = await context.read<UsdaNutritionLookupProvider>().lookup(
      foodName: _foodName.text.trim(),
      grams: grams,
    );
    if (!mounted || nutrition == null) return;
    Navigator.pop(
      context,
      ScanItem(
        name: nutrition.name.isEmpty ? _foodName.text.trim() : nutrition.name,
        amount: _grams.text.trim(),
        unit: 'g',
        kcal: nutrition.calories,
        protein: nutrition.protein,
        carbs: nutrition.carbs,
        fat: nutrition.fat,
        fiber: nutrition.fiber,
        sugar: nutrition.sugar,
        confidence: 'USDA',
      ),
    );
  }
}
