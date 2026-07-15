import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:flutter/material.dart';

class WaterHistoryList extends StatelessWidget {
  const WaterHistoryList({super.key, required this.entries});

  final List<WaterEntry> entries;

  @override
  Widget build(BuildContext context) {
    return CaloraGroupedList(
      children: entries.isEmpty
          ? const <Widget>[
              CaloraListRow(
                icon: Icons.water_drop_outlined,
                title: 'No water logged today',
              ),
            ]
          : entries
                .map(
                  (entry) => CaloraListRow(
                    icon: Icons.water_drop_outlined,
                    iconColor: context.colors.water,
                    title: '${entry.amountMl} ml',
                    subtitle: _timeLabel(entry.loggedAt),
                  ),
                )
                .toList(),
    );
  }

  String _timeLabel(DateTime value) {
    final now = DateTime.now();
    final isNow = now.difference(value).inMinutes.abs() < 2;
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period${isNow ? ' · Now' : ''}';
  }
}
