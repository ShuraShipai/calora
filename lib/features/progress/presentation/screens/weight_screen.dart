import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'weight',
      title: 'Weight',
      showBackButton: true,
    );
  }
}
