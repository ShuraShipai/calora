import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:flutter/material.dart';

class CopyMealScreen extends StatelessWidget {
  const CopyMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CaloraPage(
      screenId: 'copymeal',
      title: 'Copy a previous meal',
      child: ListView(
        children: <Widget>[
          CaloraSection(
            child: Text(
              "Pick a meal you've logged before to add it to today's diary.",
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
          ),
          CaloraSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.section),
                    child: Text('No previous meals to copy.'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
