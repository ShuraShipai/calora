import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CustomFoodDateTimeField extends StatelessWidget {
  const CustomFoodDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: context.textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      Material(
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputBorder,
          side: BorderSide(color: context.colors.borderStrong),
        ),
        child: InkWell(
          borderRadius: AppRadii.inputBorder,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.input,
            ),
            child: Row(
              children: <Widget>[
                Icon(icon, size: AppSizes.iconSmall),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
