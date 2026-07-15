import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class OnboardingTextField extends StatelessWidget {
  const OnboardingTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hint,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  final String label;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: context.textTheme.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(hintText: hint),
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: AppFontSizes.input,
            ),
          ),
        ],
      ),
    );
  }
}
