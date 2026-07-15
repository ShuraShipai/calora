import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class DiaryEmptyState extends StatelessWidget {
  const DiaryEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.x6),
    child: Column(
      children: <Widget>[
        Icon(Icons.menu_book_outlined, size: AppSizes.icon),
        SizedBox(height: AppSpacing.xl),
        Text('No meals logged today'),
      ],
    ),
  );
}
