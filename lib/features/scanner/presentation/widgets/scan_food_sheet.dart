import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:flutter/material.dart';

class ScanFoodSheet extends StatefulWidget {
  const ScanFoodSheet({super.key, this.item});

  final ScanItem? item;

  @override
  State<ScanFoodSheet> createState() => _ScanFoodSheetState();
}

class _ScanFoodSheetState extends State<ScanFoodSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _unit;
  late final TextEditingController _kcal;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name);
    _amount = TextEditingController(text: item?.amount ?? '1');
    _unit = TextEditingController(text: item?.unit);
    _kcal = TextEditingController(text: item == null ? null : '${item.kcal}');
    _protein = TextEditingController(
      text: item == null ? null : '${item.protein}',
    );
    _carbs = TextEditingController(text: item == null ? null : '${item.carbs}');
    _fat = TextEditingController(text: item == null ? null : '${item.fat}');
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _unit.dispose();
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: widget.item == null ? 'Add missing item' : 'Edit detected item',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CaloraLabeledField(
              label: 'Food name',
              hint: 'e.g. Grilled chicken',
              controller: _name,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a food name'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CaloraLabeledField(
                    label: 'Serving amount',
                    hint: '1',
                    controller: _amount,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: CaloraLabeledField(
                    label: 'Serving unit',
                    hint: 'bowl / g / cup',
                    controller: _unit,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            CaloraLabeledField(
              label: 'Calories',
              hint: 'kcal',
              controller: _kcal,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CaloraLabeledField(
                    label: 'Protein (g)',
                    controller: _protein,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: CaloraLabeledField(
                    label: 'Carbs (g)',
                    controller: _carbs,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: CaloraLabeledField(
                    label: 'Fat (g)',
                    controller: _fat,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            if (widget.item != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.error,
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    const ScanItemEditResult.removed(),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: AppSizes.iconSmall,
                  ),
                  label: const Text('Remove item'),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            CaloraActionButton(label: 'Save changes', onPressed: _save),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      ScanItemEditResult.saved(
        ScanItem(
          name: _name.text.trim(),
          amount: _amount.text.trim().isEmpty ? '1' : _amount.text.trim(),
          unit: _unit.text.trim().isEmpty ? 'serving' : _unit.text.trim(),
          kcal: int.tryParse(_kcal.text) ?? 0,
          protein: int.tryParse(_protein.text) ?? 0,
          carbs: int.tryParse(_carbs.text) ?? 0,
          fat: int.tryParse(_fat.text) ?? 0,
          confidence: 'High',
        ),
      ),
    );
  }
}
