import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class ReminderTimeSheet extends StatelessWidget {
  const ReminderTimeSheet({super.key, required this.title, required this.time});
  final String title;
  final String time;
  @override
  Widget build(BuildContext context) => Padding(
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
        CaloraLabeledField(label: 'Time', initialValue: time),
        const SizedBox(height: AppSpacing.section),
        CaloraActionButton(
          label: 'Save',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
