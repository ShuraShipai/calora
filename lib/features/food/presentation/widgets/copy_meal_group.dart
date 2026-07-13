import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:flutter/material.dart';

class CopyMealGroup extends StatelessWidget {
  const CopyMealGroup({super.key, required this.label, required this.meals});

  final String label;
  final List<(IconData, String, String)> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CaloraSectionTitle(label),
        CaloraGroupedList(
          children: <Widget>[
            for (final meal in meals)
              CaloraListRow(
                icon: meal.$1,
                title: meal.$2,
                subtitle: meal.$3,
                trailing: TextButton(
                  onPressed: () {
                    showCaloraMessage(
                      context,
                      '${meal.$2} copied to today\'s diary',
                    );
                    unawaited(
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.diary,
                        (route) => route.settings.name == AppRoutes.home,
                      ),
                    );
                  },
                  child: const Text('Copy'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
