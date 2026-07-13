import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraGroupedList extends StatelessWidget {
  const CaloraGroupedList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: AppRadii.cardBorder,
        boxShadow: context.shadows.small,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardBorder,
        child: Column(
          children: <Widget>[
            for (var index = 0; index < children.length; index++) ...<Widget>[
              children[index],
              if (index != children.length - 1)
                Divider(height: AppStrokes.thin, thickness: AppStrokes.thin),
            ],
          ],
        ),
      ),
    );
  }
}

class CaloraListRow extends StatelessWidget {
  const CaloraListRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.input,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: AppSizes.listIcon,
                height: AppSizes.listIcon,
                decoration: BoxDecoration(
                  color: context.colors.surfaceAlt,
                  borderRadius: AppRadii.inputBorder,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: AppSizes.icon,
                  color: iconColor ?? context.colors.moss,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.inkSoft,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const SizedBox(width: AppSpacing.md),
                trailing!,
              ] else if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  size: AppSizes.iconSmall,
                  color: context.colors.inkFaint,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaloraAddButton extends StatelessWidget {
  const CaloraAddButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Add',
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.addButton,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: context.colors.surfaceAlt,
          foregroundColor: context.colors.moss,
          side: BorderSide(color: context.colors.border),
        ),
        icon: const Icon(Icons.add, size: AppSizes.iconSmall),
      ),
    );
  }
}
