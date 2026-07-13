import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';

class WeightHistoryList extends StatelessWidget {
  const WeightHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return const CaloraGroupedList(
      children: <Widget>[
        CaloraListRow(icon: Icons.circle_outlined, title: 'No weight entries'),
      ],
    );
  }
}
