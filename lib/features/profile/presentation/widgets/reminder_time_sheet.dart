import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/profile/models/reminder.dart';
import 'package:flutter/material.dart';

class ReminderTimeSheet extends StatefulWidget {
  const ReminderTimeSheet({super.key, required this.reminder});
  final Reminder reminder;
  @override
  State<ReminderTimeSheet> createState() => _ReminderTimeSheetState();
}

class _ReminderTimeSheetState extends State<ReminderTimeSheet> {
  late TimeOfDay _time;
  @override
  void initState() {
    super.initState();
    _time = widget.reminder.hasTime
        ? TimeOfDay(
            hour: widget.reminder.hour!,
            minute: widget.reminder.minute!,
          )
        : TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) => CaloraSheet(
    title: widget.reminder.title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _time.format(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _pickTime,
            child: const Text('Choose time'),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        CaloraActionButton(
          label: 'Save',
          onPressed: () => Navigator.pop(
            context,
            widget.reminder.copyWith(hour: _time.hour, minute: _time.minute),
          ),
        ),
      ],
    ),
  );

  Future<void> _pickTime() async {
    final value = await showTimePicker(context: context, initialTime: _time);
    if (value != null && mounted) setState(() => _time = value);
  }
}
