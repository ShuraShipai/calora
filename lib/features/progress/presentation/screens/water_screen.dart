import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/custom_water_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/water_history_list.dart';
import 'package:calora/features/progress/presentation/widgets/water_page_body.dart';
import 'package:flutter/material.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  static const _entries = <WaterHistoryEntry>[];

  void _showAddedMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Water entry added')));
  }

  Future<void> _showCustomWaterSheet() async {
    final amount = await showCaloraSheet<int>(
      context: context,
      builder: (_) => const CustomWaterSheet(),
    );
    if (!mounted || amount == null) return;
    _showAddedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return CaloraScreenScaffold(
      screenId: 'water',
      title: 'Water',
      showBackButton: true,
      body: WaterPageBody(
        amountLabel: '0 ml',
        entries: _entries,
        onAdd250: _showAddedMessage,
        onAdd500: _showAddedMessage,
        onCustom: _showCustomWaterSheet,
      ),
    );
  }
}
