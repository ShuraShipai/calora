import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class ScanResultsScreen extends StatelessWidget {
  const ScanResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'scanresults',
      title: 'Scan result',
      showBackButton: true,
    );
  }
}
