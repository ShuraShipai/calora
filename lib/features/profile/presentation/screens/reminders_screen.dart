import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/features/profile/presentation/widgets/reminder_time_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/reminders_list.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});
  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<bool> _enabled = <bool>[true, true, false, true, true, false];
  static const _titles = <String>[
    'Breakfast reminder',
    'Lunch reminder',
    'Dinner reminder',
    'Water reminder',
    'Weight logging reminder',
    'Daily logging reminder',
  ];
  static const _times = <String>[
    '8:00 AM',
    '1:00 PM',
    '8:00 PM',
    'Every 2 hours',
    'Sundays, 9:00 AM',
    '9:30 PM, if diary is empty',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    key: const ValueKey<String>('reminders'),
    body: SafeArea(
      child: ListView(
        children: <Widget>[
          const ProfilePageHeader(title: 'Reminders'),
          ProfileSection(
            child: RemindersList(
              enabled: _enabled,
              onEnabled: (index) =>
                  setState(() => _enabled[index] = !_enabled[index]),
              onEdit: _showTimeEditor,
            ),
          ),
        ],
      ),
    ),
  );
  void _showTimeEditor(int index) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        ReminderTimeSheet(title: _titles[index], time: _times[index]),
  );
}
