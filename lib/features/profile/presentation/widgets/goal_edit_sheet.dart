import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class GoalEditSheet extends StatefulWidget {
  const GoalEditSheet({
    super.key,
    required this.title,
    required this.value,
    required this.onSave,
  });
  final String title;
  final String value;
  final Future<bool> Function(double value) onSave;

  @override
  State<GoalEditSheet> createState() => _GoalEditSheetState();
}

class _GoalEditSheetState extends State<GoalEditSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.sheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: AppSizes.sheetHandleWidth,
              height: AppSizes.sheetHandleHeight,
              decoration: BoxDecoration(
                color: context.colors.borderStrong,
                borderRadius: AppRadii.pillBorder,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(widget.title, style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.section),
          CaloraLabeledField(
            label: 'Goal',
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          CaloraActionButton(label: 'Save goal', onPressed: _save),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final value = double.tryParse(_controller.text.trim());
    if (value == null) return;
    final saved = await widget.onSave(value);
    if (mounted && saved) Navigator.pop(context);
  }
}
