import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/diary_food_source.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/scanner/models/meal_label_suggestion.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:calora/features/scanner/models/scanner_request.dart';
import 'package:calora/features/scanner/presentation/widgets/meal_label_suggestions.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_estimate_notice.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_food_sheet.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_items_list.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_meal_picker.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_nutrition_summary.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_result_image.dart';
import 'package:calora/features/scanner/presentation/widgets/usda_food_confirmation_sheet.dart';
import 'package:calora/features/scanner/providers/barcode_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResultsScreen extends StatefulWidget {
  const ScanResultsScreen({super.key});

  @override
  State<ScanResultsScreen> createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  final _items = <ScanItem>[];
  String _meal = 'Lunch';
  ScannerRequest? _request;
  bool _saving = false;
  bool _barcodeSaveCompleted = false;
  bool _barcodeLookupStarted = false;

  ScannerRequest get request => _request ?? const ScannerRequest.meal();

  void _resolveRequest() {
    if (_request != null) return;
    _request = ModalRoute.of(context)?.settings.arguments as ScannerRequest?;
    _meal = request.mealType.label;
    if (request.mode == ScannerMode.barcode && request.barcodeValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookupBarcode());
    }
  }

  Future<void> _lookupBarcode() async {
    if (_barcodeLookupStarted || !mounted) return;
    final barcode = request.barcodeValue;
    if (barcode == null) return;
    _barcodeLookupStarted = true;
    final product = await context.read<BarcodeLookupProvider>().lookup(barcode);
    if (!mounted) return;
    if (product == null) {
      showCaloraMessage(
        context,
        context.read<BarcodeLookupProvider>().errorMessage ??
            'No product found for this barcode.',
      );
      return;
    }
    setState(() {
      _items.add(
        ScanItem(
          name: product.name,
          amount: '1',
          unit: product.servingLabel,
          kcal: product.calories,
          protein: product.protein,
          carbs: product.carbs,
          fat: product.fat,
          confidence: 'Database',
        ),
      );
    });
  }

  Future<void> _saveToDiary() async {
    if (request.mode == ScannerMode.barcode) {
      await _saveBarcodeToDiary();
      return;
    }
    if (_items.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final meal = MealTypeX.fromStored(_meal);
      for (final item in _items) {
        await context.read<DiaryProvider>().add(
          DiaryEntry(
            id: '',
            meal: meal.storedValue,
            name: item.name,
            serving: '${item.amount} ${item.unit}',
            calories: item.kcal,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
            fiber: item.fiber,
            sugar: item.sugar,
            loggedAt: DateTime.now(),
            source: request.mode == ScannerMode.barcode
                ? DiaryFoodSource.barcode
                : DiaryFoodSource.scanned,
          ),
        );
      }
      if (!mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.diary,
        (route) => route.settings.name == AppRoutes.home,
      );
    } catch (_) {
      if (mounted) showCaloraMessage(context, 'Could not save diary entries.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveBarcodeToDiary() async {
    if (_items.isEmpty || _saving || _barcodeSaveCompleted) return;
    setState(() => _saving = true);
    try {
      final meal = MealTypeX.fromStored(_meal);
      for (final item in _items) {
        await context.read<DiaryProvider>().add(
          DiaryEntry(
            id: '',
            meal: meal.storedValue,
            name: item.name,
            serving: '${item.amount} ${item.unit}',
            calories: item.kcal,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
            fiber: item.fiber,
            sugar: item.sugar,
            loggedAt: DateTime.now(),
            source: DiaryFoodSource.barcode,
          ),
        );
      }
      if (!mounted) return;
      _barcodeSaveCompleted = true;
      unawaited(
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.diary,
          (route) => route.settings.name == AppRoutes.home,
        ),
      );
    } catch (_) {
      if (mounted) showCaloraMessage(context, 'Could not save diary entries.');
    } finally {
      if (mounted && !_barcodeSaveCompleted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _editItem(int? index) async {
    final result = await showCaloraSheet<ScanItemEditResult>(
      context: context,
      showDragHandle: false,
      cardStyle: true,
      builder: (context) =>
          ScanFoodSheet(item: index == null ? null : _items[index]),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (result.removed && index != null) {
        _items.removeAt(index);
      } else if (result.item != null && index == null) {
        _items.add(result.item!);
      } else if (result.item != null && index != null) {
        _items[index] = result.item!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _resolveRequest();
    return CaloraPage(
      screenId: 'scanresults',
      title: 'Scan result',
      child: ListView(
        children: <Widget>[
          const CaloraSection(child: ScanResultImage()),
          if (request.mealLabelSuggestions.isNotEmpty)
            CaloraSection(
              child: MealLabelSuggestions(
                suggestions: request.mealLabelSuggestions,
                onSelected: (suggestion) =>
                    unawaited(_addSuggestion(suggestion)),
              ),
            ),
          CaloraSection(child: ScanNutritionSummary(items: _items)),
          const CaloraSection(child: ScanEstimateNotice()),
          CaloraSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const CaloraSectionTitle('Detected items — tap to edit'),
                ScanItemsList(
                  items: _items,
                  onEdit: (index) => unawaited(_editItem(index)),
                  onRemove: (index) => setState(() => _items.removeAt(index)),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => unawaited(_editItem(null)),
                    icon: const Icon(Icons.add, size: AppSizes.iconSmall),
                    label: const Text('Add missing item'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                ScanMealPicker(
                  meal: _meal,
                  onChanged: (value) => setState(() => _meal = value),
                ),
              ],
            ),
          ),
          CaloraSection(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CaloraActionButton(
                    label: 'Scan again',
                    style: CaloraActionButtonStyle.secondary,
                    onPressed: () => unawaited(
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.scanner,
                        arguments: request,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: CaloraActionButton(
                    label: 'Save to diary',
                    onPressed: _items.isEmpty || _saving ? null : _saveToDiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSuggestion(MealLabelSuggestion suggestion) async {
    final item = await showCaloraSheet<ScanItem>(
      context: context,
      builder: (context) => UsdaFoodConfirmationSheet(suggestion: suggestion),
    );
    if (!mounted || item == null) return;
    setState(() => _items.add(item));
  }
}
