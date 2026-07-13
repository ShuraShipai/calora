import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

Future<T?> showCaloraSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.authContentMaxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(child: builder(context)),
        ),
      ),
    ),
  );
}

class CaloraSheet extends StatelessWidget {
  const CaloraSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: AppSpacing.section),
          Text(title, style: context.textTheme.titleLarge),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.section),
          child,
        ],
      ),
    );
  }
}
