import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

Future<T?> showCaloraSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool showDragHandle = true,
  bool cardStyle = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: showDragHandle,
    backgroundColor: cardStyle ? Colors.transparent : null,
    builder: (context) {
      final content = ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.authContentMaxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(child: builder(context)),
        ),
      );
      if (!cardStyle) return Center(child: content);
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.page,
          AppSpacing.page,
          AppSpacing.page,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.authContentMaxWidth,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: context.colors.surface,
                borderRadius: AppRadii.largeBorder,
                clipBehavior: Clip.antiAlias,
                child: content,
              ),
            ),
          ),
        ),
      );
    },
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
