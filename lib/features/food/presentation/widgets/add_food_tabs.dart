import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:flutter/material.dart';

class AddFoodTabs extends StatelessWidget {
  const AddFoodTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var index = 0; index < tabs.length; index++) ...<Widget>[
            CaloraChoiceChip(
              label: tabs[index],
              selected: selected == tabs[index],
              onTap: () => onSelected(tabs[index]),
            ),
            if (index != tabs.length - 1) const SizedBox(width: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
