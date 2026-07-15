import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/presentation/widgets/diary_empty_state.dart';
import 'package:flutter/material.dart';

class DiaryEntryList extends StatelessWidget {
  const DiaryEntryList({
    super.key,
    required this.entries,
    required this.onDelete,
  });
  final List<DiaryEntry> entries;
  final ValueChanged<DiaryEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const DiaryEmptyState();
    return Column(
      children: <Widget>[
        for (final entry in entries)
          Card(
            child: ListTile(
              title: Text(entry.name),
              subtitle: Text(
                '${entry.meal} · ${entry.serving} · ${entry.calories} kcal',
              ),
              trailing: IconButton(
                tooltip: 'Remove ${entry.name}',
                onPressed: () => onDelete(entry),
                icon: Icon(Icons.delete_outline, color: context.colors.error),
              ),
            ),
          ),
      ],
    );
  }
}
