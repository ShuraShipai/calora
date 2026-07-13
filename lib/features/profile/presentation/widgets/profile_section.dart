import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, this.title, required this.child, this.top});

  final String? title;
  final Widget child;
  final double? top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        top ?? 0,
        AppSpacing.page,
        AppSpacing.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Text(
              title!.toUpperCase(),
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colors.inkFaint,
                fontWeight: AppFontWeights.bold,
                letterSpacing: AppSpacing.xs + AppSpacing.xxs,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          child,
        ],
      ),
    );
  }
}
