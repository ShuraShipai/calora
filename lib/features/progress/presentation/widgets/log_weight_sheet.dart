import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:flutter/material.dart';

class LogWeightSheet extends StatefulWidget {
  const LogWeightSheet({super.key, this.unitSystem});
  final UnitSystem? unitSystem;

  @override
  State<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<LogWeightSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _loggedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateLabel(_loggedAt);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _loggedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selected == null) return;
    setState(() {
      _loggedAt = selected;
      _dateController.text = _dateLabel(selected);
    });
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
              label: 'Date',
              controller: _dateController,
              keyboardType: TextInputType.datetime,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _selectDate,
                child: const Text('Choose date'),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
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
                    loggedAt: _loggedAt,
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

  String _dateLabel(DateTime value) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
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
