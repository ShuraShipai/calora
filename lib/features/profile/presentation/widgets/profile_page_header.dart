import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      child: Row(
        children: <Widget>[
          SizedBox.square(
            dimension: AppSizes.iconButton,
            child: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.surface,
                foregroundColor: context.colors.ink,
                side: BorderSide(color: context.colors.border),
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.chevron_left),
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Text(title, style: context.textTheme.headlineSmall),
        ],
      ),
    );
  }
}
