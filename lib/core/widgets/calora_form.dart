import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraLabeledField extends StatelessWidget {
  const CaloraLabeledField({
    super.key,
    required this.label,
    this.initialValue,
    this.hint,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  final String label;
  final String? initialValue;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: context.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: controller == null ? initialValue : null,
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class CaloraChoiceChip extends StatelessWidget {
  const CaloraChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? context.colors.moss : context.colors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? context.colors.moss : context.colors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: selected ? context.colors.onAccent : context.colors.ink,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
      ),
    );
  }
}
