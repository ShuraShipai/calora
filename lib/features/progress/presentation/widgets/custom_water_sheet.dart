import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class CustomWaterSheet extends StatefulWidget {
  const CustomWaterSheet({super.key});

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
              label: 'Amount (ml)',
              hint: 'e.g. 350',
              controller: _controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                final amount = int.tryParse(value?.trim() ?? '');
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
                Navigator.pop(context, int.parse(_controller.text.trim()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
