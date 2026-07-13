import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autofillHints,
    this.onFieldSubmitted,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: context.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(hintText: hint),
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: AppFontSizes.input,
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          autofillHints: autofillHints,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
        ),
      ],
    );
  }
}
