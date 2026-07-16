import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/profile/models/reminder.dart';
import 'package:calora/features/profile/providers/reminder_provider.dart';
import 'package:calora/features/profile/presentation/widgets/reminder_time_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/reminders_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    key: const ValueKey<String>('reminders'),
    body: SafeArea(
      child: ListView(
        children: <Widget>[
          const ProfilePageHeader(title: 'Reminders'),
          ProfileSection(
            child: RemindersList(
              reminders: context.watch<ReminderProvider>().reminders,
              onChanged: (reminder) => _save(context, reminder),
              onEdit: (reminder) => _showTimeEditor(context, reminder),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _showTimeEditor(BuildContext context, Reminder reminder) async {
    final updated = await showCaloraSheet<Reminder>(
      context: context,
      showDragHandle: false,
      cardStyle: true,
      builder: (_) => ReminderTimeSheet(reminder: reminder),
    );
    if (updated != null && context.mounted) await _save(context, updated);
  }

  Future<void> _save(BuildContext context, Reminder reminder) async {
    final saved = await context.read<ReminderProvider>().save(reminder);
    if (!context.mounted || saved) return;
    final message = context.read<ReminderProvider>().errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Could not save reminder.')),
    );
  }
}
