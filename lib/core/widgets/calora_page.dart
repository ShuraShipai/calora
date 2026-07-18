import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraPage extends StatelessWidget {
  const CaloraPage({
    super.key,
    required this.screenId,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final String screenId;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey<String>(screenId),
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.authContentMaxWidth,
            ),
            child: Column(
              children: <Widget>[
                if (title != null) CaloraTopBar(title: title!),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class CaloraIconButton extends StatelessWidget {
  const CaloraIconButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = AppSizes.iconButton,
    this.iconSize = AppSizes.icon,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colors.surface,
          foregroundColor: color ?? context.colors.ink,
          side: BorderSide(color: context.colors.border),
          shadowColor: context.shadows.small.first.color,
          elevation: AppElevations.low,
        ),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}

class CaloraSection extends StatelessWidget {
  const CaloraSection({
    super.key,
    required this.child,
    this.bottom = AppSpacing.section,
    this.top = 0,
  });

  final Widget child;
  final double bottom;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        top,
        AppSpacing.page,
        bottom,
      ),
      child: child,
    );
  }
}

class CaloraSectionTitle extends StatelessWidget {
  const CaloraSectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colors.inkSoft,
        ),
      ),
    );
  }
}

void showCaloraMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: AppDurations.toast),
    );
}
