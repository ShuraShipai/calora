import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.prompt,
    required this.action,
    required this.onPressed,
  });

  final String prompt;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: <Widget>[
        Text(
          prompt,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: AppFontSizes.bodySmall,
            color: context.colors.inkSoft,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, AppSpacing.x3),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          child: Text(action),
        ),
      ],
    );
  }
}
