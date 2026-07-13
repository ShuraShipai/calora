import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class MealAddFoodButton extends StatelessWidget {
  const MealAddFoodButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSizes.addButton),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.add, size: AppSizes.iconSmall),
      label: const Text('+ Add food'),
    );
  }
}
