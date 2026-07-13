import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class CopyMealScreen extends StatelessWidget {
  const CopyMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'copymeal',
      title: 'Copy a previous meal',
      showBackButton: true,
    );
  }
}
