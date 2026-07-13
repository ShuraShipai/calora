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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CaloraLabeledField(
            label: 'Amount (ml)',
            hint: 'e.g. 350',
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.section),
          CaloraActionButton(
            label: 'Add',
            onPressed: () => Navigator.pop(
              context,
              int.tryParse(_controller.text.trim()) ?? 350,
            ),
          ),
        ],
      ),
    );
  }
}
