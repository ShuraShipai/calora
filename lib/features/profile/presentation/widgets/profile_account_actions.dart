import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ProfileAccountActions extends StatelessWidget {
  const ProfileAccountActions({
    super.key,
    required this.onLogOut,
    required this.onDeleteAccount,
  });

  final VoidCallback onLogOut;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge?.copyWith(
      color: context.colors.error,
      fontWeight: AppFontWeights.semiBold,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton.icon(
          onPressed: onLogOut,
          icon: const Icon(Icons.logout_outlined, size: AppSizes.iconSmall),
          label: const Text('Log out'),
          style: TextButton.styleFrom(
            foregroundColor: context.colors.error,
            textStyle: style,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        TextButton.icon(
          onPressed: onDeleteAccount,
          icon: const Icon(Icons.delete_outline, size: AppSizes.iconSmall),
          label: const Text('Delete account'),
          style: TextButton.styleFrom(
            foregroundColor: context.colors.error,
            textStyle: style,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
