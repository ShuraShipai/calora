import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';

class RemindersList extends StatelessWidget {
  const RemindersList({
    super.key,
    required this.enabled,
    required this.onEnabled,
    required this.onEdit,
  });
  final List<bool> enabled;
  final ValueChanged<int> onEnabled;
  final ValueChanged<int> onEdit;

  static const _items = <(IconData, String, String)>[
    (Icons.breakfast_dining_outlined, 'Breakfast reminder', '8:00 AM'),
    (Icons.lunch_dining_outlined, 'Lunch reminder', '1:00 PM'),
    (Icons.dinner_dining_outlined, 'Dinner reminder', '8:00 PM'),
    (Icons.water_drop_outlined, 'Water reminder', 'Every 2 hours'),
    (Icons.near_me_outlined, 'Weight logging reminder', 'Sundays, 9:00 AM'),
    (
      Icons.eco_outlined,
      'Daily logging reminder',
      '9:30 PM, if diary is empty',
    ),
  ];

  @override
  Widget build(BuildContext context) => CaloraGroupedList(
    children: List<Widget>.generate(_items.length, (index) {
      final item = _items[index];
      return CaloraListRow(
        icon: item.$1,
        iconColor: index == 3 ? context.colors.water : context.colors.inkSoft,
        title: item.$2,
        subtitle: item.$3,
        onTap: () => onEdit(index),
        trailing: Switch.adaptive(
          value: enabled[index],
          onChanged: (_) => onEnabled(index),
        ),
      );
    }),
  );
}
