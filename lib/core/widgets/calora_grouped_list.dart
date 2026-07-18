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
