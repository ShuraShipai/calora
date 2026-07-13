import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class GoalEditSheet extends StatelessWidget {
  const GoalEditSheet({super.key, required this.title, required this.value});
  final String title;
  final String value;

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
          Text(title, style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.section),
          CaloraLabeledField(
            label: 'Goal',
            initialValue: value,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          CaloraActionButton(
            label: 'Save goal',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
