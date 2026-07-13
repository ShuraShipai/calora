import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'water',
      title: 'Water',
      showBackButton: true,
    );
  }
}
