import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/profile/models/reminder.dart';
import 'package:flutter/material.dart';

class RemindersList extends StatelessWidget {
  const RemindersList({
    super.key,
    required this.reminders,
    required this.onChanged,
    required this.onEdit,
    required this.isBusy,
  });
  final List<Reminder> reminders;
  final ValueChanged<Reminder> onChanged;
  final ValueChanged<Reminder> onEdit;
  final bool isBusy;

  @override
  Widget build(BuildContext context) => CaloraGroupedList(
    children: reminders
        .map((reminder) {
          return CaloraListRow(
            icon: _iconFor(reminder.kind),
            iconColor: reminder.kind == ReminderKind.water
                ? context.colors.water
                : context.colors.inkSoft,
            title: reminder.title,
            subtitle: reminder.scheduleLabel,
            onTap: isBusy ? null : () => onEdit(reminder),
            trailing: Switch.adaptive(
              value: reminder.enabled,
              onChanged: (enabled) =>
                  onChanged(reminder.copyWith(enabled: enabled)),
            ),
          );
        })
        .toList(growable: false),
  );

  IconData _iconFor(ReminderKind kind) => switch (kind) {
    ReminderKind.breakfast => Icons.breakfast_dining_outlined,
    ReminderKind.lunch => Icons.rice_bowl_outlined,
    ReminderKind.dinner => Icons.local_pizza_outlined,
    ReminderKind.water => Icons.water_drop_outlined,
    ReminderKind.weight => Icons.near_me_outlined,
    ReminderKind.diary => Icons.eco_outlined,
  };
}
