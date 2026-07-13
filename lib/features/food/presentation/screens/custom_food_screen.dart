import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class CustomFoodScreen extends StatelessWidget {
  const CustomFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'customfood',
      title: 'Custom food',
      showBackButton: true,
    );
  }
}
