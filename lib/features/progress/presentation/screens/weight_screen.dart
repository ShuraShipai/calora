import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/log_weight_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/weight_page_body.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  void _showLogWeightSheet(BuildContext context) {
    showCaloraSheet<void>(
      context: context,
      builder: (_) => const LogWeightSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CaloraScreenScaffold(
      screenId: 'weight',
      title: 'Weight',
      showBackButton: true,
      body: WeightPageBody(onLogWeight: () => _showLogWeightSheet(context)),
    );
  }
}
