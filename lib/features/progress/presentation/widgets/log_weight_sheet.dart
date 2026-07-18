import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class LogWeightSheet extends StatefulWidget {
  const LogWeightSheet({super.key, this.unitSystem});
  final UnitSystem? unitSystem;

  @override
  State<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<LogWeightSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: 'Log weight',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CaloraLabeledField(
              label: widget.unitSystem == UnitSystem.imperial
                  ? 'Weight (lb)'
                  : 'Weight (kg)',
              hint: 'e.g. 67.5',
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final weight = double.tryParse(value?.trim() ?? '');
                return weight == null || weight <= 0
                    ? 'Enter a weight greater than 0.'
                    : null;
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            CaloraLabeledField(
              label: 'Note (optional)',
              hint: 'How are you feeling?',
              controller: _noteController,
            ),
            const SizedBox(height: AppSpacing.section),
            CaloraActionButton(
              label: 'Save entry',
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                Navigator.pop(
                  context,
                  WeightEntryDraft(
                    weightKg: MeasurementFormatter.weightToKg(
                      double.parse(_weightController.text.trim()),
                      widget.unitSystem,
                    ),
                    loggedAt: DateTime.now(),
                    note: _noteController.text.trim(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeightEntryDraft {
  const WeightEntryDraft({
    required this.weightKg,
    required this.loggedAt,
    required this.note,
  });

  final double weightKg;
  final DateTime loggedAt;
  final String note;
}
