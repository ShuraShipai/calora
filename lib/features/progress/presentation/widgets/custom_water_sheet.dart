import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class CustomWaterSheet extends StatefulWidget {
  const CustomWaterSheet({super.key, this.unitSystem});
  final UnitSystem? unitSystem;

  @override
  State<CustomWaterSheet> createState() => _CustomWaterSheetState();
}

class _CustomWaterSheetState extends State<CustomWaterSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CaloraSheet(
      title: 'Add water',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CaloraLabeledField(
              label: widget.unitSystem == UnitSystem.imperial
                  ? 'Amount (fl oz)'
                  : 'Amount (L)',
              hint: widget.unitSystem == UnitSystem.imperial
                  ? 'e.g. 12'
                  : 'e.g. 0.35',
              controller: _controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                return amount == null || amount <= 0
                    ? 'Enter an amount greater than 0.'
                    : null;
              },
            ),
            const SizedBox(height: AppSpacing.section),
            CaloraActionButton(
              label: 'Add',
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                Navigator.pop(
                  context,
                  MeasurementFormatter.waterToMillilitres(
                    double.parse(_controller.text.trim()),
                    widget.unitSystem,
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
