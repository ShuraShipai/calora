import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class ProgressFilterChips extends StatelessWidget {
  const ProgressFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _labels = <String>['Week', 'Month', '3 months', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(_labels.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == _labels.length - 1 ? 0 : AppSpacing.md,
            ),
            child: CaloraChoiceChip(
              label: _labels[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          );
        }),
      ),
    );
  }
}
