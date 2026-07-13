import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class LogWeightSheet extends StatelessWidget {
  const LogWeightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: 'Log weight',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CaloraLabeledField(label: 'Date', initialValue: '13 Jul 2026'),
          const SizedBox(height: AppSpacing.xxl),
          const CaloraLabeledField(
            label: 'Weight (kg)',
            hint: 'e.g. 67.5',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const CaloraLabeledField(
            label: 'Note (optional)',
            hint: 'How are you feeling?',
          ),
          const SizedBox(height: AppSpacing.section),
          CaloraActionButton(
            label: 'Save entry',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
