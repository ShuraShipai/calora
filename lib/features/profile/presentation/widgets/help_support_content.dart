import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';

class HelpSupportContent extends StatelessWidget {
  const HelpSupportContent({super.key, required this.onContactSupport});

  final VoidCallback onContactSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CaloraGroupedList(
          children: const <Widget>[
            CaloraListRow(
              icon: Icons.restaurant_outlined,
              title: 'How do I log food?',
              subtitle:
                  'Open Diary and choose Add food to search, scan, or create an entry.',
            ),
            CaloraListRow(
              icon: Icons.near_me_outlined,
              title: 'How do I change my goals or units?',
              subtitle:
                  'Use Health goals or Units from your Profile dashboard.',
            ),
            CaloraListRow(
              icon: Icons.notifications_none,
              title: 'How do reminders work?',
              subtitle: 'Manage meal, water, and logging reminders in Profile.',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        CaloraGroupedList(
          children: <Widget>[
            CaloraListRow(
              icon: Icons.mail_outline,
              title: 'Contact support',
              subtitle: 'Get help with your Calora account or diary.',
              onTap: onContactSupport,
            ),
          ],
        ),
      ],
    );
  }
}
