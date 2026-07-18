import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/profile/models/reminder.dart';
import 'package:flutter/material.dart';

enum _IntervalUnit { minutes, hours }

class WaterReminderSheet extends StatefulWidget {
  const WaterReminderSheet({super.key, required this.reminder});

  final Reminder reminder;

  @override
  State<WaterReminderSheet> createState() => _WaterReminderSheetState();
}

class _WaterReminderSheetState extends State<WaterReminderSheet> {
  late final TextEditingController _intervalController;
  late _IntervalUnit _unit;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _error;

  @override
  void initState() {
    super.initState();
    final interval = widget.reminder.waterIntervalMinutes ?? 120;
    _unit = interval % 60 == 0 ? _IntervalUnit.hours : _IntervalUnit.minutes;
    _intervalController = TextEditingController();
    _startTime = TimeOfDay(
      hour: widget.reminder.hour ?? 8,
      minute: widget.reminder.minute ?? 0,
    );
    _endTime = TimeOfDay(
      hour: widget.reminder.waterEndHour ?? 20,
      minute: widget.reminder.waterEndMinute ?? 0,
    );
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CaloraSheet(
    title: 'Water reminder',
    subtitle:
        'Choose how often to be reminded and the hours to keep reminders active.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CaloraLabeledField(
          label: 'Repeat every',
          controller: _intervalController,
          hint: 'e.g. 2',
          keyboardType: TextInputType.number,
          selectAllOnTap: true,
          onChanged: (_) => setState(() => _error = null),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          children: _IntervalUnit.values
              .map(
                (unit) => CaloraChoiceChip(
                  label: unit == _IntervalUnit.hours ? 'Hours' : 'Minutes',
                  selected: _unit == unit,
                  onTap: () => setState(() {
                    final current = int.tryParse(_intervalController.text);
                    if (current != null) {
                      _intervalController.text = switch ((_unit, unit)) {
                        (_IntervalUnit.hours, _IntervalUnit.minutes) =>
                          (current * 60).toString(),
                        (_IntervalUnit.minutes, _IntervalUnit.hours) =>
                          (current / 60).ceil().toString(),
                        _ => current.toString(),
                      };
                    }
                    _unit = unit;
                    _error = null;
                  }),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: AppSpacing.section),
        _TimeField(
          label: 'Start time',
          value: _startTime,
          onTap: () => _pickTime(start: true),
        ),
        const SizedBox(height: AppSpacing.section),
        _TimeField(
          label: 'End time',
          value: _endTime,
          onTap: () => _pickTime(start: false),
        ),
        if (_error != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Text(
            _error!,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.section),
        CaloraActionButton(label: 'Save', onPressed: _save),
      ],
    ),
  );

  Future<void> _pickTime({required bool start}) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: start ? _startTime : _endTime,
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (start) {
        _startTime = selected;
      } else {
        _endTime = selected;
      }
      _error = null;
    });
  }

  void _save() {
    final value = int.tryParse(_intervalController.text);
    if (value == null || value <= 0) {
      setState(() => _error = 'Enter a repeat interval greater than zero.');
      return;
    }
    final interval = _unit == _IntervalUnit.hours ? value * 60 : value;
    final start = _startTime.hour * 60 + _startTime.minute;
    final end = _endTime.hour * 60 + _endTime.minute;
    if (end <= start) {
      setState(() => _error = 'End time must be later than the start time.');
      return;
    }
    Navigator.pop(
      context,
      widget.reminder.copyWith(
        hour: _startTime.hour,
        minute: _startTime.minute,
        waterIntervalMinutes: interval,
        waterEndHour: _endTime.hour,
        waterEndMinute: _endTime.minute,
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: context.textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      OutlinedButton(
        onPressed: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(value.format(context)),
        ),
      ),
    ],
  );
}
