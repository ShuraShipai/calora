import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:flutter/material.dart';

class WaterQuickAddButtons extends StatelessWidget {
  const WaterQuickAddButtons({
    super.key,
    required this.onAdd250,
    required this.onAdd500,
    required this.onCustom,
  });

  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CaloraActionButton(
            label: '+250 ml',
            onPressed: onAdd250,
            style: CaloraActionButtonStyle.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: CaloraActionButton(
            label: '+500 ml',
            onPressed: onAdd500,
            style: CaloraActionButtonStyle.secondary,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: CaloraActionButton(
            label: 'Custom',
            onPressed: onCustom,
            style: CaloraActionButtonStyle.secondary,
          ),
        ),
      ],
    );
  }
}
