import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:flutter/material.dart';

class AddFoodResults extends StatelessWidget {
  const AddFoodResults({super.key, required this.foods});

  final List<(String, String, String)> foods;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.loose,
        ),
        child: Text(
          'No foods match your search. Try a different term, or create a custom food.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.inkSoft,
          ),
        ),
      );
    }

    return CaloraGroupedList(
      children: <Widget>[
        for (final food in foods)
          CaloraListRow(
            icon: Icons.circle_outlined,
            title: food.$2,
            subtitle: food.$3,
            trailing: CaloraAddButton(
              tooltip: 'Add ${food.$2}',
              onPressed: () {
                showCaloraMessage(context, '${food.$2} added to diary');
                unawaited(
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.diary,
                    (route) => route.settings.name == AppRoutes.home,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
