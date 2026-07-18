import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_icon_button.dart';
import 'package:flutter/material.dart';

class CaloraTopBar extends StatelessWidget {
  const CaloraTopBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

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
          CaloraIconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.maybePop(context),
            icon: Icons.chevron_left,
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(child: Text(title, style: context.textTheme.headlineSmall)),
          if (trailing case final Widget trailing) trailing,
        ],
      ),
    );
  }
}
