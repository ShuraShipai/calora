import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/scanner/models/scan_item.dart';
import 'package:flutter/material.dart';

class ScanItemsList extends StatelessWidget {
  const ScanItemsList({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onRemove,
  });

  final List<ScanItem> items;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return CaloraGroupedList(
      children: <Widget>[
        for (var index = 0; index < items.length; index++)
          CaloraListRow(
            icon: Icons.circle_outlined,
            title: items[index].name,
            subtitle: items[index].details,
            onTap: () => onEdit(index),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: items[index].confidence == 'High'
                        ? context.colors.mossTint
                        : context.colors.surfaceAlt,
                    borderRadius: AppRadii.pillBorder,
                  ),
                  child: Text(
                    items[index].confidence,
                    style: context.textTheme.labelSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit ${items[index].name}',
                  onPressed: () => onEdit(index),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: AppSizes.iconSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Remove ${items[index].name}',
                  onPressed: () => onRemove(index),
                  color: context.colors.error,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: AppSizes.iconSmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
