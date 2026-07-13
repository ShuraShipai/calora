import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
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
    if (entries.isEmpty) return const _DiaryEmptyState();
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

class _DiaryEmptyState extends StatelessWidget {
  const _DiaryEmptyState();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.x6),
    child: Column(
      children: <Widget>[
        Icon(Icons.menu_book_outlined, size: AppSizes.icon),
        SizedBox(height: AppSpacing.xl),
        Text('No meals logged today'),
      ],
    ),
  );
}
