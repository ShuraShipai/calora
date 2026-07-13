import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ProfileConfirmActionSheet extends StatelessWidget {
  const ProfileConfirmActionSheet({
    super.key,
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;

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
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: FilledButton(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.error,
                    foregroundColor: context.colors.onAccent,
                  ),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
