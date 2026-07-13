import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class AddFoodSearchField extends StatelessWidget {
  const AddFoodSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Search foods',
        prefixIcon: Icon(Icons.search, size: AppFontSizes.sheetTitle),
      ),
    );
  }
}
