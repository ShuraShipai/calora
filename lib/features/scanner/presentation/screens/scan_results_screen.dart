import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_estimate_notice.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_food_sheet.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_items_list.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_meal_picker.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_nutrition_summary.dart';
import 'package:calora/features/scanner/presentation/widgets/scan_result_image.dart';
import 'package:flutter/material.dart';

class ScanResultsScreen extends StatefulWidget {
  const ScanResultsScreen({super.key});

  @override
  State<ScanResultsScreen> createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  final _items = <ScanItem>[];
  String _meal = 'Lunch';

  Future<void> _editItem(int? index) async {
    final result = await showCaloraSheet<ScanItemEditResult>(
      context: context,
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
    return CaloraPage(
      screenId: 'scanresults',
      title: 'Scan result',
      child: ListView(
        children: <Widget>[
          const CaloraSection(child: ScanResultImage()),
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: CaloraActionButton(
                    label: 'Save to diary',
                    onPressed: () => unawaited(
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.diary,
                        (route) => route.settings.name == AppRoutes.home,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
