import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';

class WaterHistoryList extends StatelessWidget {
  const WaterHistoryList({super.key, required this.entries});

  final List<WaterHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return CaloraGroupedList(
      children: entries
          .map(
            (entry) => CaloraListRow(
              icon: Icons.water_drop_outlined,
              iconColor: context.colors.water,
              title: '${entry.amount} ml',
              subtitle: entry.time,
            ),
          )
          .toList(),
    );
  }
}

class WaterHistoryEntry {
  const WaterHistoryEntry({required this.amount, required this.time});

  final int amount;
  final String time;
}
