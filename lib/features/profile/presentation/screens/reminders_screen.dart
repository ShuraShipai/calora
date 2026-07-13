import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraScreenScaffold(
      screenId: 'reminders',
      title: 'Reminders',
      showBackButton: true,
    );
  }
}
