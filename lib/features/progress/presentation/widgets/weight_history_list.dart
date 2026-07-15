import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:flutter/material.dart';

class WeightHistoryList extends StatelessWidget {
  const WeightHistoryList({super.key, required this.entries});

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    return CaloraGroupedList(
      children: entries.isEmpty
          ? const <Widget>[
              CaloraListRow(
                icon: Icons.circle_outlined,
                title: 'No weight entries',
              ),
            ]
          : entries
                .map(
                  (entry) => CaloraListRow(
                    icon: Icons.circle_outlined,
                    title: '${entry.weightKg.toStringAsFixed(1)} kg',
                    subtitle: _subtitle(entry),
                  ),
                )
                .toList(),
    );
  }

  String _subtitle(WeightEntry entry) {
    final date = entry.loggedAt;
    final today = DateTime.now();
    final dateLabel =
        date.year == today.year &&
            date.month == today.month &&
            date.day == today.day
        ? 'Today'
        : '${date.day}/${date.month}/${date.year}';
    final note = entry.note;
    return note == null || note.isEmpty ? dateLabel : '$dateLabel · $note';
  }
}
